@echo OFF
set "sections=sections/"
set "templates=templates/"
set "meta=meta/"
IF "%~1"=="" (
    set "NAME=Resume"
) ELSE (
    set "NAME=%*"
)

RD /S /Q output
mkdir output

python scripts/generate.py

docker run --rm -v "%cd%:/data" pandoc/minimal:edge output/sidebar.md -o output/sidebar.tex
docker run --rm -v "%cd%:/data" pandoc/minimal:edge output/before.md -A output/sidebar.tex -o output/sidebar.tex --template=%templates%subsections.tex --metadata-file %meta%main.yaml
docker run --rm -v "%cd%:/data" pandoc/minimal:edge^
    output/main.md ^
    -B output/sidebar.tex ^
    -o output/out.tex ^
    --template=%templates%main.tex ^
    --metadata-file %meta%main.yaml ^
    --metadata-file %meta%contact.yaml ^
    --metadata-file %meta%legal-pl.yaml
docker run --rm -v "%cd%:/data" -it --entrypoint bash pandoc/extra:edge-ubuntu scripts/convert_to_pdf.sh

move output\out.pdf %NAME%.pdf
RD /S /Q output
