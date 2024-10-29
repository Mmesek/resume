import yaml

SECTIONS_DIR = "sections/"
CONFIG_DIR = "configs/"
META_DIR = "meta/"
OUTPUT_DIR = "output/"


def load(filename: str) -> dict:
    with open(filename, "r", newline="", encoding="utf-8") as file:
        return yaml.safe_load(file)


def dump(filename: str, data) -> None:
    with open(filename, "w", newline="", encoding="utf-8") as file:
        yaml.safe_dump(data, file)


def read(filename: str) -> str:
    with open(filename, "r", newline="", encoding="utf-8") as file:
        return file.read()


def save(filename: str, content: str) -> None:
    print(f"Saving to {filename}")
    with open(OUTPUT_DIR + filename, "w", newline="", encoding="utf-8") as file:
        file.write(content)
