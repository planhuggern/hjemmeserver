#!/usr/bin/env bash

set -u

SOURCE="/srv/storage/downloads"
DEST="/srv/storage/media/Movies"

mkdir -p "$DEST"

clean_name() {
    local name="$1"

    # Fjern filendelse
    name="${name%.*}"

    # Bytt punktum og underscore med mellomrom
    name="${name//./ }"
    name="${name//_/ }"

    # Fjern vanlige release-tags og alt etter dem
    name="$(echo "$name" | sed -E \
        's/[[:space:]]+(2160p|1080p|720p|480p|4K|UHD|BluRay|BRRip|BDRip|WEB[-. ]?DL|WEBRip|HDRip|DVDRip|HDTV|REMUX|x264|x265|H264|H265|HEVC|AV1|AAC|AC3|DTS|DDP|Atmos|HDR10|HDR|DV|PROPER|REPACK).*//I')"

    # Fjern release group på slutten, f.eks. "-GROUP"
    name="$(echo "$name" | sed -E 's/[[:space:]]*-[[:space:]]*[A-Za-z0-9]+$//')"

    # Fjern ekstra mellomrom
    name="$(echo "$name" | sed -E 's/[[:space:]]+/ /g; s/^ //; s/ $//')"

    echo "$name"
}

find "$SOURCE" -type f \( \
    -iname '*.mkv' -o \
    -iname '*.mp4' -o \
    -iname '*.m4v' -o \
    -iname '*.avi' -o \
    -iname '*.mov' -o \
    -iname '*.webm' -o \
    -iname '*.mpg' -o \
    -iname '*.mpeg' \
\) -print0 |
while IFS= read -r -d '' file; do

    filename="$(basename "$file")"
    extension="${filename##*.}"
    cleaned="$(clean_name "$filename")"

    # Finn årstall mellom 1900 og 2099 hvis det finnes
    year="$(echo "$cleaned" | grep -oE '(19|20)[0-9]{2}' | tail -1 || true)"

    if [[ -n "$year" ]]; then
        # Alt før siste forekomst av årstallet blir tittel
        title="$(echo "$cleaned" | sed -E "s/[[:space:]]*${year}.*$//")"
        title="$(echo "$title" | sed -E 's/[[:space:]]+/ /g; s/^ //; s/ $//')"

        movie_name="$title ($year)"
    else
        movie_name="$cleaned"
    fi

    # Sikkerhetsnett
    if [[ -z "$movie_name" ]]; then
        echo "Hopper over, klarte ikke navn: $file" >&2
        continue
    fi

    movie_dir="$DEST/$movie_name"
    target="$movie_dir/$movie_name.$extension"

    if [[ -e "$target" ]]; then
        echo "Finnes allerede: $target"
        continue
    fi

    mkdir -p "$movie_dir"

    if ln "$file" "$target"; then
        echo "Linket:"
        echo "  $file"
        echo "  -> $target"
    else
        echo "FEIL: Kunne ikke hardlinke $file" >&2
        rmdir "$movie_dir" 2>/dev/null || true
    fi

done
