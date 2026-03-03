#!/bin/bash
INPUT="$*"
if echo "$INPUT" | grep -qE 'https?://'; then
    bash /home/xh004/.openclaw/workspace/skills/url-policy-analyzer/scripts/analyze.sh url $INPUT
else
    bash /home/xh004/.openclaw/workspace/skills/url-policy-analyzer/scripts/analyze.sh search "$INPUT"
fi
