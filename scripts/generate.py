import os
import sys

from dataclasses import dataclass

import utils

# NOTE:
# - Parse certificate
# - Left/right icon
# - Dynamic projects fetching through GH API

USE_HTML = sys.argv[-1] == "--html"


def make_div(string: str) -> str:
    if USE_HTML:
        return rf"\n<div>\n{string}\n</div>\n"
    return string


def parse_object(
    objects: dict[str, str | int | list | dict], level: int = 0, section: str = None
) -> str:
    string = ""
    _parser = None
    spidergraph = False
    for key, value in objects.items():
        if key == "include":
            value = utils.load(utils.CONFIG_DIR + value)

        if not section and level == 0 and key == "main":
            section = "main"
        elif level == 0:
            section = None

        if key == "name":
            if value == "Spidergraph":
                spidergraph = True
            else:
                if section == "main":
                    value = rf"{{icon}} \ {value}"
                else:
                    value = f"{value} {{icon}}"
                string += f"\n{'#' * level} {value}\n"
        elif key == "include_parser":
            _parser = value
        elif key == "file":
            if value.endswith("/"):
                value = os.listdir(utils.SECTIONS_DIR + value)
            if type(value) is not list:
                value = [value]

            for item in value:
                string += utils.read(utils.SECTIONS_DIR + item) + "\n"
        elif key == "icon":
            string = string.format(icon=value)
        elif key == "cloud":
            string += make_cloud(value) + "\n"
        elif key == "list":
            string += make_list(value, spidergraph) + "\n"
            spidergraph = False

        elif type(value) is list:
            for object in value:
                if type(object) is dict:
                    if _parser == "certificates":
                        string += parse_certficate(object, level + 1)
                    elif _parser == "extra":
                        string += parse_description(object, level + 1)
                    elif _parser == "education":
                        string += parse_description(object, level + 1)
                    else:
                        string += make_div(
                            parse_object(object, level=level + 1, section=section)
                        )
                else:
                    string += object + "\n"
        elif type(value) is dict:
            string += make_div(parse_object(value, level=level + 1, section=section))

        if level == 0:
            utils.save(key + ".md", string.strip())
            string = ""
    return string


@dataclass
class Certificate:
    name: str
    date: int
    url: str = None
    id: str = None
    default: bool = False
    categories: list = list

    def __str__(self) -> str:
        if self.url:
            return f"[**{self.name}**]({self.url})"
        return f"**{self.name}**"


def parse_certficate(object: dict, level: int):
    header = "\n" + " " + object["organisation"] + r"\hfill\ "
    if len(object["certificates"]) == 1:
        return header + str(Certificate(**object["certificates"][0])) + "\n"
    return (
        header
        + "\n"
        + "\n\n".join([f"- {Certificate(**cert)}" for cert in object["certificates"]])
        + "\n"
    )


def parse_description(object: dict, level: int):
    return (
        "\n- "
        + str(Certificate(object["name"], None, url=object.get("link", None)))
        + (f"\n*{object['date']}*\n\n" if "date" in object else "")
        + " "
        + object["description"]
    )


@dataclass
class Skill:
    name: str
    proficiency: int
    description: str = None

    def __str__(self) -> str:
        if not self.description:
            meter = r"\meter{" + str(self.proficiency) + "/10}"
        else:
            meter = f"- {self.description} •"

        if USE_HTML:
            return f'<meter value="{self.proficiency}" max="10">{meter}</meter>'
        return meter

    def left(self) -> str:
        return str(self) + " " + self.name

    def right(self) -> str:
        return self.name + " " + str(self)


def make_list(items: list[str], is_spidergraph: bool = False) -> str:
    new_items = []
    for item in items:
        if type(item) is dict:
            new_items.append(Skill(**item))
        else:
            new_items.append(item)
    grouped = []
    from itertools import zip_longest

    new_items = sorted(
        new_items, key=lambda x: getattr(x, "proficiency", x), reverse=True
    )
    if is_spidergraph:
        return "\\spidergraph{{{}}}".format(
            ", ".join(f"{k.name}/{k.proficiency}" for k in new_items)
        )
    left, right = new_items[: len(new_items) // 2], new_items[len(new_items) // 2 :]
    for a, b in zip_longest(left, right):
        # for (a, b) in grouper(sorted(new_items, key=lambda x: x.proficiency, reverse=True), 2):
        if (a and a.description) or (b and b.description):
            grouped.append(a.right())
            grouped.append(b.right())
        elif a and b:
            grouped.append(a.left() + r" \hfill " + b.right())
        else:
            grouped.append(a.right() if a else b.right())
    return "\n".join([f"- {i}" for i in grouped])


def make_cloud(items: list[str]) -> str:
    if USE_HTML:
        return "- " + " ".join([f"<cloudtag>{i}</cloudtag>" for i in items])
    return "- " + " ".join([r"\cloudtag{{i}}".replace("{i}", i) for i in items])


if __name__ == "__main__":
    print(parse_object(utils.load(utils.CONFIG_DIR + "sections.yml")))
