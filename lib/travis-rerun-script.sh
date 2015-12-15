# DO NOT CALL THIS DIRECTLY. USE travis-rerun INSTEAD.

set -e

if [[ -z $1 || -z $2 ]]; then
  usage
fi

create_script() {
  cd $SRC_PATH
  safe_clone https://github.com/$repo_slug
  repo_path=$(echo $repo_slug |  awk -F\/ '{print $NF}')
  # remove trialing .git
  repo_path="${repo_path%.*}"
  cd $repo_path
  yes | travis compile $job_no
}

log "creating build script for job $job_no..."
create_script
