for i in themes/all/*; do
  if [ -d "$i" ]; then
    base=$(basename $i)
    hugo server -w --theme=all/${base} &
    pid=$!
    ./phantomjs-2.0.0-windows/bin/phantomjs.exe ./themepreview.js http://localhost:1313 "themepreviews/$base.pdf"
    kill -9 $pid
  fi
done
