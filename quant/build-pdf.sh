#!/usr/bin/env bash
# Regenerate quant/Quant_Standard_v0.1.0.pdf from the Markdown source.
# Requires: pandoc, tectonic (brew install pandoc tectonic)
set -euo pipefail
cd "$(dirname "$0")"
pandoc Quant_Standard_v0.1.0.md -o Quant_Standard_v0.1.0.pdf --pdf-engine=tectonic
echo "Wrote Quant_Standard_v0.1.0.pdf"
