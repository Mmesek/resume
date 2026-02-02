templates="templates"
meta="meta"
config="configs"
IMAGE="pandoc/typst"

ORANGE="\033[38;2;255;165;0m"
BLUE="\033[0;34m"
RESET="\033[0m"

if [ -z "$1" ]; then
    NAME="Resume"
else
    NAME="$*"
fi
echo -e "File will be saved as $ORANGE$NAME$RESET.pdf"

if which docker > /dev/null 2>&1; then
    ENGINE=docker;
else which podman > /dev/null;
    ENGINE=podman
fi
echo -e "Using $ORANGE$ENGINE$RESET as containerization engine"

echo -e "${BLUE}Converting$RESET to PDF"
$ENGINE run --rm -it \
    -v "$(pwd):/data" \
    -v ~/.fonts:/root/.fonts \
    --entrypoint=typst \
    $IMAGE \
    compile \
    $templates/main.typ \
    $NAME.pdf \
    --input author=$NAME \
    --input sections=../$config/sections.yml \
    --input meta=../$meta/main.yaml \
    --input contact=../$meta/contact.yaml \
    --root=..


echo -e "${BLUE}Done$RESET, cleaning up"
