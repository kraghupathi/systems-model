#!/bin/bash
dir="automation-scripts"

prepend_text="
#+PROPERTY: session *scratch*
#+PROPERTY: results output
#+PROPERTY: tangle ../build/dummyfile.yml
#+PROPERTY: exports code

Explain whatever in org mode style..

#+BEGIN_SRC YAML"

append_text="#+END_SRC"

for file in `find $dir -type f -name "*.y*ml"`; do
  # get path to file relative to $dir
  #echo $file
  dir_frm_here=$(dirname $file)
  #echo $dir_frm_here
  if [ $dir_frm_here == $dir ]; then
    dirn=""
  else
    dirn="${dir_frm_here#*$dir/}"
  fi
  #echo "dir: $dirn"

  # get the filename separately
  filename=$(basename $file)
  filename="${filename%.*}"
  #echo "filename: $filename"

  # prepare the build path
  if [ -z "$dirn" ]; then
    build_path="$filename"
  else
    build_path="$dirn/$filename"
  fi

  prepend_str="${prepend_text/dummyfile/$build_path}"
  #echo "$prepend_str"
  echo "$prepend_str" | cat - $file > /tmp/out && mv /tmp/out $file
  echo $append_text >> $file
  mv $file `echo $file | sed 's/\(.*\.\)yaml/\1txt/'`
  echo "$file -> `echo $file | sed 's/\(.*\.\)yaml/\1txt/'`"
done
