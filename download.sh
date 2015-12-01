wget -O index.html https://www.topcoder.com/community/data-science/data-science-tutorials/
grep '\"https://www.topcoder.com/community/data-science/data-science-tutorials' index.html > jump2.txt
while IFS= read line
do
  line=${line// }
  line=${line%% }
  echo $line >> jump.txt
done < jump2.txt
while IFS= read line
do
  line=${line// }
  line=${line%% }
  starti="$(echo $line | grep -aob '"' | grep -oE '[0-9]+' | sed "1q;d")"
	endi="$(echo $line | grep -aob '"' | grep -oE '[0-9]+' | sed "2q;d")"
  length=$((endi-starti))
	link=${line:$((starti+1)):$((length-1))}
  echo $link
  wget -O page.html -o log.txt $link
  title="$(sed -n "6p" page.html)"
  title=${title// }
  title=${title%% }
  title=${title/<title>}
  title=${title%</title>}
  title=${title/&#8211;/-}
  html2pdf page.html $title.pdf
done < jump.txt
rm jump.txt
rm jump2.txt
rm log.txt
rm page.html
