#!/bin/bash
# Create a GitHub release with the compiled PDF
set -e

readonly PDF_PATH='main.pdf'
if [[ ! -f "$PDF_PATH" ]]; then
    >&2 echo "Expected $PDF_PATH to exist but it doesn't."
    exit 1
fi

git_user() { git config --get user.name ; }
git_rev() { git rev-parse --short HEAD ; }
working_tree_clean() { [[ -z "$(git status --porcelain --untracked-files=no)" ]] ; }
has_untracked_files() { [[ -n "$(git ls-files --other --exclude-standard)" ]] ; }

prompt_yn_default_n_abort() {
    local msg="$1"
    read -n 1 -p "$msg [y/N] " answer
    echo
    case $answer in
        [Yy]) ;;
        *) echo "Abort." >&2; exit 1 ;;
    esac
}

if ! working_tree_clean; then
    prompt_yn_default_n_abort "Working tree has uncommitted changes. Proceed?"
fi

if has_untracked_files; then
    prompt_yn_default_n_abort "Working tree has untracked files. Proceed?"
fi

readonly NOW_UTC="$(date -u +'%Y-%m-%d %H:%M:%S') UTC"
readonly GIT_TAG="snapshot-$(date +%s)"
readonly RELEASE_NAME="PDF at $NOW_UTC"
readonly NOTES_FILE="$(mktemp -t release_notes.XXXXXX)"

cat <<EOF > "$NOTES_FILE"
* Uploaded by: $(git_user)
* At revision: $(git_rev)
* Timestamp: $NOW_UTC
* Working tree clean: $(working_tree_clean && echo ✅ || echo ❌)
* Has untracked files: $(has_untracked_files && echo ❌ || echo ✅)
EOF

gh release create "$GIT_TAG" \
    --title "$RELEASE_NAME" \
    --notes-file "$NOTES_FILE" \
    "$PDF_PATH"
