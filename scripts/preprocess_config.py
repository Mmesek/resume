from datetime import datetime

import pytz

import utils


def parse_timezone(tz: str):
    sign = ""
    dt = datetime.now(pytz.timezone(tz.split(" ", 1)[0]))
    if (offset := dt.utcoffset().total_seconds()) > 0:
        sign = "+"

    return f"{dt.tzname()} / UTC{sign}{int(offset // 3600)}"


def convert(cfg: dict[str, str]) -> None:
    if tz := cfg.get("timezone", None):
        cfg["timezone"] = parse_timezone(tz.split(" ", 1)[0])
    utils.dump(utils.OUTPUT_DIR + "main.yaml", cfg)


convert(utils.load(utils.META_DIR + "main.yaml"))
