#!/usr/bin/env python3

from typing import TextIO

from supervisor.events import ProcessLogEvent


def exec(event: ProcessLogEvent, headers: dict[str, str],
         text_lines: list[str], file_out: TextIO) -> None:
    ch = headers['channel']
    if ch == 'stdout':
        ch = 'O'
    if ch == 'stderr':
        ch = 'E'

    prefix = f'{headers['processname']}.{ch}: '

    for line in text_lines:
        if ch == 'E' and not line.startswith((
            'Accepted publickey for ',
            'Disconnected from user ',
        )):
            continue

        print(f'{prefix}{line}', file=file_out)
