export HOST=${HOST:-"0.0.0.0"}
#export HOST=${HOST:-"localhost"}
export PORT=${PORT:-3735}

export DEV_DIR="public"
export BUILD_DIR="build"

export SRC_JS="app/main.cjsx"
export OUT_JS="main.js"
export VENDOR_JS="vendor.js"

export SRC_CSS="css/main.styl"
export OUT_CSS="main.css"

export SRC_HTML="./views/index.ejs"
export OUT_HTML="index.html"

export HEAD_COMMIT=$(git rev-parse HEAD)

# NOTE: Non-dev dependencies are assumed to be front-end modules.
externals=$(node -p "Object.keys(require('./package').dependencies).join('\n');")

function flag_externals {
  out=""
  for module in $externals; do
    # Symlinked modules are assumed to be in development and aren't externalized.
    # JSPlumb is broken.
    if [[ "$module" != "jsplumb" ]]; then
      [[ -L "node_modules/$module" ]] || out="$out --$1 $module"
    fi
  done
  echo $out
}

function rename_with_hash {
  if hash md5sum 2>/dev/null
    then checksum=$(md5sum "$1" | cut -d " " -f 1)
    else checksum=$(md5 -q "$1")
  fi
  fullname=$(basename "$1")
  filename="${fullname%.*}"
  extension="${fullname##*.}"
  echo "$filename.$checksum.$extension"
}
