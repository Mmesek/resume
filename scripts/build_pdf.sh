sections="sections"
templates="templates"
meta="meta"
IMAGE="pandoc/extra:edge-ubuntu"

ORANGE="\033[38;2;255;165;0m"
BLUE="\033[0;34m"
RESET="\033[0m"

if [ -z "$1" ]; then
    NAME="Resume"
else
    NAME="$*"
fi
echo -e "File will be saved as $ORANGE$NAME$RESET.pdf"

echo -e "${BLUE}Preparing$RESET output directory"
rm -rf output
mkdir output

if which docker > /dev/null 2>&1; then
    ENGINE=docker;
else which podman > /dev/null;
    ENGINE=podman
fi
echo -e "Using $ORANGE$ENGINE$RESET as containerization engine"

echo -e "${BLUE}Generating$RESET markdown files from configuration definitions"
python scripts/generate.py
python scripts/preprocess_config.py

echo -e "${BLUE}Building$RESET ${ORANGE}sidebar$RESET.tex"
$ENGINE run --rm -v "$(pwd):/data" $IMAGE output/sidebar.md -o output/sidebar.tex
$ENGINE run --rm -v "$(pwd):/data" $IMAGE output/before.md -A output/sidebar.tex -o output/sidebar.tex --template=$templates/subsections.tex --metadata-file output/main.yaml

echo -e "${BLUE}Building$RESET ${ORANGE}main$RESET.tex"
$ENGINE run --rm -v "$(pwd):/data" $IMAGE \
    output/main.md \
    -B output/sidebar.tex \
    -o output/out.tex \
    --template=$templates/main.tex \
    --metadata-file output/main.yaml \
    --metadata-file $meta/contact.yaml \
    --metadata-file $meta/legal-pl.yaml

echo -e "${BLUE}Converting$RESET to PDF"
$ENGINE run --rm -v "$(pwd):/data" -it --entrypoint bash $IMAGE scripts/convert_to_pdf.sh > /dev/null

echo -e "${BLUE}Done$RESET, cleaning up"
mv output/out.pdf $NAME.pdf
rm -rf output
