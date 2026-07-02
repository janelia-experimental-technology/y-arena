#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
ARCHIVE_DIR=${ARCHIVE_DIR:-"/home/peter/Sites/peterpolidoro/projects.peterpolidoro.net/janelia/y-arena"}
REPOS_DIR="$ARCHIVE_DIR/repos"
SITE_ROOT="/home/peter/Sites/peterpolidoro/projects.peterpolidoro.net"
README_ASSETS_DIR="$SITE_ROOT/assets/readme"
README_CSS_HREF="/assets/readme/readme.css"
VENV_DIR=${VENV_DIR:-"$ROOT_DIR/.venv-docs"}
PANDOC_BIN=${PANDOC_BIN:-"$(command -v pandoc)"}
MKDOCS_PY="$VENV_DIR/bin/python"
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

mkdir -p "$REPOS_DIR"

write_repos_index() {
  cat > "$REPOS_DIR/index.html" <<'EOF'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Y-Arena Local Source Files</title>
    <link rel="stylesheet" href="/assets/readme/readme.css" />
  </head>
  <body class="readme-page">
    <main class="readme-shell">
      <p class="pp-breadcrumbs">
        <a href="/index.htm">projects</a>/
        <a href="/janelia/janelia.htm">janelia</a>/
        <a href="/janelia/y-arena/index.html">Y-Arena</a>/
      </p>
      <header class="readme-hero">
        <p class="readme-kicker">Project Sources</p>
        <h1>Local Source Files</h1>
        <p class="readme-summary">These local copies replace GitHub and GitHub Pages links used by the Y-Arena documentation.</p>
      </header>
      <section class="readme-body">
        <div class="readme-card-grid">
          <a class="readme-card" href="y-arena-source/">
            <strong>y-arena</strong>
            <span>source files</span>
          </a>
          <a class="readme-card" href="y_arena_odor_controller/">
            <strong>y_arena_odor_controller</strong>
            <span>hardware files</span>
          </a>
          <a class="readme-card" href="YArenaOdorController/">
            <strong>YArenaOdorController</strong>
            <span>firmware files</span>
          </a>
          <a class="readme-card" href="y_arena_odor_controller_ros/">
            <strong>y_arena_odor_controller_ros</strong>
            <span>software files</span>
          </a>
          <a class="readme-card" href="docker_setup/">
            <strong>docker_setup</strong>
            <span>notes</span>
          </a>
          <a class="readme-card" href="raspberrypi_setup/">
            <strong>raspberrypi_setup</strong>
            <span>notes</span>
          </a>
        </div>
      </section>
    </main>
  </body>
</html>
EOF
}

render_markup_page() {
  local format="$1"
  local src="$2"
  local dest="$3"
  local title="$4"
  local kicker="$5"
  local summary="$6"
  local fragment="$TMP_DIR/$(basename "$dest").fragment.html"
  "$PANDOC_BIN" --from "$format" --to html5 --no-highlight --wrap=none "$src" > "$fragment"

  {
    cat <<EOF
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>$title</title>
    <link rel="stylesheet" href="$README_CSS_HREF" />
  </head>
  <body class="readme-page">
    <main class="readme-shell">
      <p class="pp-breadcrumbs">
        <a href="/index.htm">projects</a>/
        <a href="/janelia/janelia.htm">janelia</a>/
        <a href="/janelia/y-arena/index.html">Y-Arena</a>/
      </p>
      <header class="readme-hero">
        <p class="readme-kicker">$kicker</p>
        <h1>$title</h1>
        <p class="readme-summary">$summary</p>
      </header>
      <article class="readme-body">
EOF
    cat "$fragment"
    cat <<'EOF'
      </article>
    </main>
  </body>
</html>
EOF
  } > "$dest"
}

inject_repo_breadcrumbs() {
  local file

  while IFS= read -r -d '' file; do
    if ! grep -q "$README_CSS_HREF" "$file"; then
      perl -0pi -e 's@</head>@  <link rel="stylesheet" href="'"$README_CSS_HREF"'" />\n</head>@' "$file"
    fi

    if grep -q 'class="pp-breadcrumbs"' "$file"; then
      continue
    fi

    if grep -q '<article class="md-content__inner md-typeset">' "$file"; then
      perl -0pi -e 's@(<article class="md-content__inner md-typeset">\s*)@$1<p class="pp-breadcrumbs"><a href="/index.htm">projects</a>/ <a href="/janelia/janelia.htm">janelia</a>/ <a href="/janelia/y-arena/index.html">Y-Arena</a>/</p>\n@' "$file"
    else
      perl -0pi -e 's@(<body[^>]*>\s*)@$1<p class="pp-breadcrumbs"><a href="/index.htm">projects</a>/ <a href="/janelia/janelia.htm">janelia</a>/ <a href="/janelia/y-arena/index.html">Y-Arena</a>/</p>\n@' "$file"
    fi
  done < <(find "$REPOS_DIR" -type f -name '*.html' -print0)
}

build_kicad_archive() {
  local src="/home/peter/Repositories/kicad/y_arena_odor_controller"
  local dest="$REPOS_DIR/y_arena_odor_controller"
  local cfg="$TMP_DIR/y_arena_odor_controller-mkdocs.yml"

  cat > "$cfg" <<'EOF'
site_name: y_arena_odor_controller
site_description: This board controls the y-arena odors for the Janelia Turner lab
site_author: Peter Polidoro
site_url: ''
docs_dir: /home/peter/Repositories/kicad/y_arena_odor_controller/docs

copyright: 'Copyright &copy; 2020 Peter Polidoro'

theme:
  name: 'material'
  language: en
  logo: 'img/y_logo.png'
  feature:
    tabs: true
  palette:
    primary: indigo
    accent: Deep Purple
  font: false

extra:
  generator: false

markdown_extensions:
  - admonition
  - pymdownx.details
  - pymdownx.superfences
  - codehilite:
      guess_lang: true

nav:
  - Home: index.md
  - Schematic:
    - schematic00: schematic/schematic00.md
    - schematic01: schematic/schematic01.md
    - schematic02: schematic/schematic02.md
    - schematic03: schematic/schematic03.md
    - schematic04: schematic/schematic04.md
    - schematic05: schematic/schematic05.md
    - schematic06: schematic/schematic06.md
    - schematic07: schematic/schematic07.md
    - schematic08: schematic/schematic08.md
    - schematic09: schematic/schematic09.md
  - Gerbers:
    - gerbers00: gerbers/gerbers00.md
    - gerbers01: gerbers/gerbers01.md
  - Bill of Materials:
    - PCB Parts: bom/pcb.md
    - Supplemental Parts: bom/supplemental.md
EOF

  "$MKDOCS_PY" -m mkdocs build --clean -f "$cfg" -d "$dest"
  touch "$dest/.nojekyll"
}

build_y_arena_source_archive() {
  local src="$ROOT_DIR"
  local dest="$REPOS_DIR/y-arena-source"
  local page="$TMP_DIR/y-arena-source.org"

  rm -rf "$dest"
  mkdir -p "$dest"
  rsync -a \
    --exclude '.git' \
    --exclude '.venv' \
    --exclude '.venv-docs' \
    --exclude 'site' \
    --exclude 'standalone-site' \
    "$src/README.org" "$src/LICENSE" "$src/mkdocs.yml" "$src/mkdocs-standalone.yml" \
    "$src/docs" "$src/setup" "$src/firmware" "$src/hardware" "$src/software" \
    "$dest/"

  cat > "$page" <<'EOF'
#+TITLE: y-arena source files

This local copy stores the Y-Arena source files referenced by the setup instructions.

* Key Files
- [[./README.org]]
- [[./LICENSE]]
- [[./mkdocs-standalone.yml]]
- [[./setup/README.org]]
- [[./setup/ycontroller_setup]]
- [[./setup/HOST_SETUP_WINDOWS.org]]

EOF
  sed \
    -e 's#https://github.com/janelia-experimental-technology/y-arena#./#g' \
    -e 's#https://janelia-experimental-technology.github.io/y-arena/#../../index.html#g' \
    "$src/README.org" >> "$page"

  render_markup_page org "$page" "$dest/index.html" "y-arena source files" "Repository README" "Local source files and project notes for Y-Arena."
}

build_arduino_archive() {
  local src="/home/peter/Repositories/arduino/YArenaOdorController"
  local dest="$REPOS_DIR/YArenaOdorController"
  local page="$TMP_DIR/YArenaOdorController.org"

  rm -rf "$dest"
  mkdir -p "$dest"
  rsync -a \
    --exclude '.git' \
    "$src/README.org" "$src/LICENSE" "$src/library.properties" "$src/platformio.ini" \
    "$src/api" "$src/examples" "$src/src" \
    "$dest/"

  cat > "$page" <<'EOF'
#+TITLE: YArenaOdorController source files

This local copy stores the YArenaOdorController firmware source files.

* Key Files
- [[./README.org]]
- [[./LICENSE]]
- [[./library.properties]]
- [[./platformio.ini]]
- [[./api/YArenaOdorController.json]]
- [[./examples/YArenaOdorController/YArenaOdorController.ino]]
- [[./src/YArenaOdorController.h]]

EOF
  sed -E \
    -e 's#https://github.com/janelia-arduino/YArenaOdorController#./#g' \
    -e 's#\[\[\./api/\]\]#\[\[./api/YArenaOdorController.json\]\]#g' \
    -e 's#\[\[(https://github\.com/[^]]+)\]\]#=\1=#g' \
    "$src/README.org" >> "$page"

  render_markup_page org "$page" "$dest/index.html" "YArenaOdorController source files" "Repository README" "Firmware source files and README content for YArenaOdorController."
}

build_ros_archive() {
  local src="/home/peter/Repositories/ros/y_arena_odor_controller_ros"
  local dest="$REPOS_DIR/y_arena_odor_controller_ros"
  local page="$TMP_DIR/y_arena_odor_controller_ros.org"

  rm -rf "$dest"
  mkdir -p "$dest"
  rsync -a \
    --exclude '.git' \
    "$src/README.org" "$src/LICENSE" "$src/Dockerfile" \
    "$src/y_arena_cpp_pub" "$src/y_arena_interfaces" "$src/y_arena_odor_controller" "$src/y_arena_python_pub" \
    "$dest/"

  cat > "$page" <<'EOF'
#+TITLE: y_arena_odor_controller_ros source files

This local copy stores the ROS software source files referenced by the Y-Arena setup and usage pages.

* Key Files
- [[./README.org]]
- [[./LICENSE]]
- [[./Dockerfile]]
- [[./y_arena_interfaces/msg/ArenaOdors.msg]]
- [[./y_arena_interfaces/srv/GetArenas.srv]]
- [[./y_arena_odor_controller/launch/controller.launch.py]]
- [[./y_arena_cpp_pub/src/y_arena_cpp_pub.cpp]]
- [[./y_arena_python_pub/y_arena_python_pub/y_arena_python_pub.py]]

EOF
  sed \
    -e 's#\[\[https://github.com/janelia-experimental-technology/y-arena\]\]#\[\[../../index.html\]\]#g' \
    "$src/README.org" >> "$page"

  render_markup_page org "$page" "$dest/index.html" "y_arena_odor_controller_ros source files" "Repository README" "Software source files and README content for y_arena_odor_controller_ros."
}

build_docker_setup_archive() {
  local src="/home/peter/Repositories/jet/docker_setup"
  local dest="$REPOS_DIR/docker_setup"
  local page="$TMP_DIR/docker_setup.org"
  local mac_page="$TMP_DIR/DOCKER_SETUP_MAC_OS_X.org"

  rm -rf "$dest"
  mkdir -p "$dest"
  rsync -a --exclude '.git' "$src/README.org" "$src/LICENSE" "$src/DOCKER_SETUP_LINUX.org" "$src/DOCKER_SETUP_WINDOWS.org" "$dest/"

  cat > "$page" <<'EOF'
#+TITLE: docker_setup notes

This local copy stores the docker setup notes referenced by the Y-Arena setup pages.

* Available Documents
- [[./README.org]]
- [[./DOCKER_SETUP_LINUX.html]]
- [[./DOCKER_SETUP_WINDOWS.html]]
- [[./DOCKER_SETUP_MAC_OS_X.html]]

EOF
  sed \
    -e 's#https://github.com/janelia-experimental-technology/docker_setup/blob/master/DOCKER_SETUP_LINUX.org#./DOCKER_SETUP_LINUX.html#g' \
    -e 's#https://github.com/janelia-experimental-technology/docker_setup/blob/master/DOCKER_SETUP_WINDOWS.org#./DOCKER_SETUP_WINDOWS.html#g' \
    -e 's#https://github.com/janelia-experimental-technology/docker_setup/blob/master/DOCKER_SETUP_MAC_OS_X.org#./DOCKER_SETUP_MAC_OS_X.html#g' \
    "$src/README.org" >> "$page"

  cat > "$mac_page" <<'EOF'
#+TITLE: DOCKER_SETUP_MAC_OS_X

No =DOCKER_SETUP_MAC_OS_X.org= file was present in this source tree snapshot.
EOF

  render_markup_page org "$page" "$dest/index.html" "docker_setup notes" "Repository README" "Setup notes and supporting documents for Docker-based host configuration."
  render_markup_page org "$src/DOCKER_SETUP_LINUX.org" "$dest/DOCKER_SETUP_LINUX.html" "DOCKER_SETUP_LINUX" "Setup Notes" "Linux Docker setup notes."
  render_markup_page org "$src/DOCKER_SETUP_WINDOWS.org" "$dest/DOCKER_SETUP_WINDOWS.html" "DOCKER_SETUP_WINDOWS" "Setup Notes" "Windows Docker setup notes."
  render_markup_page org "$mac_page" "$dest/DOCKER_SETUP_MAC_OS_X.html" "DOCKER_SETUP_MAC_OS_X" "Setup Notes" "Mac Docker setup notes."
}

build_raspberrypi_archive() {
  local src="/home/peter/Repositories/jet/raspberrypi_setup"
  local dest="$REPOS_DIR/raspberrypi_setup"
  local page="$TMP_DIR/raspberrypi_setup.org"

  rm -rf "$dest"
  mkdir -p "$dest"
  rsync -a --exclude '.git' "$src/README.org" "$src/LICENSE" "$src/etc" "$dest/"

  cat > "$page" <<'EOF'
#+TITLE: raspberrypi_setup notes

This local copy stores the Raspberry Pi setup notes referenced by the Y-Arena ycontroller setup page.

* Key Files
- [[./README.org]]
- [[./LICENSE]]
- [[./etc/udev/rules.d/]]
- [[../docker_setup/DOCKER_SETUP_LINUX.html]]

EOF
  sed \
    -e 's#https://github.com/janelia-experimental-technology/docker_setup/blob/master/DOCKER_SETUP_LINUX.org#../docker_setup/DOCKER_SETUP_LINUX.html#g' \
    "$src/README.org" >> "$page"

  render_markup_page org "$page" "$dest/index.html" "raspberrypi_setup notes" "Repository README" "Raspberry Pi setup notes and supporting files for ycontroller."
}

write_repos_index
build_y_arena_source_archive
build_kicad_archive
build_arduino_archive
build_ros_archive
build_docker_setup_archive
build_raspberrypi_archive
inject_repo_breadcrumbs

printf 'Local source files written to %s\n' "$REPOS_DIR"
