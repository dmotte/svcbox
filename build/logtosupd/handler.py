#!/usr/bin/env python3

import sys

from supervisor.events import ProcessLogEvent

from . import process as logtosupd_process


# Inspired by
# https://github.com/coderanger/supervisor-stdout/blob/master/supervisor_stdout.py


def event_handler(event: ProcessLogEvent, response_bytes: bytes) -> None:
    response_str = response_bytes.decode('utf-8')

    headers_line, text = response_str.split('\n', 1)
    headers = dict(x.split(':', 1) for x in headers_line.split())
    text_lines = text.splitlines()

    logtosupd_process.exec(event, headers, text_lines, sys.stdout)
    sys.stdout.flush()
