#!/bin/bash

echo "Content-Type: text/html"
echo

UPTIME_SEP='\.'

format() {
    cat | sed -e 's/</\&lt/g
                  s/>/\&gt/g' | \
    perl -ne'my @cols = split /\s+/, $_;
             chop $cols[4];
             if($cols[5] !~ "^/proc" and $cols[5] !~ "^/dev" and $cols[5] !~ "^/sys") {
                 if($cols[4] ne "Use" and $cols[4] > 90) {
                     print "<tr style=\"background-color: red\"><td>".$cols[0];
                 } elsif($cols[4] ne "Use" and $cols[4] > 80) {
                     print "<tr style=\"background-color: orange\"><td>".$cols[0];
                 } else {
                     print "<tr><td>".$cols[0];
                 }
                 print "</td><td>".$cols[1]."</td><td>".$cols[2]."</td><td>".$cols[3]."</td><td>".$cols[4]."%</td><td>".$cols[5]."</td></tr>";
             }
            '
}

STYLE="body {}
       .ap_ax {}"

LoadAvg=$(echo $UPTIME_SEP | perl -e 'my $i = <>;
                                      chomp $i;
                                      `uptime` =~ /(\d+$i\d+).*(\d+$i\d+).*(\d+$i\d+)/;
                                      print $1'
         )

LoadAvg=$(echo $LoadAvg|sed -e's/\,/./')

Cores=$(cat /proc/cpuinfo | grep -c 'core id')

if [ $(perl -e"print $LoadAvg > $Cores") ]
then
    STYLE="$STYLE
           .loadavg { background-color:red }"
elif [ $(perl -e"print(($LoadAvg + 0.3) > $Cores)") ]
then
    STYLE="$STYLE
           .loadavg { background-color:orange }"
else
    STYLE="$STYLE
           .loadavg { background-color:green }"
fi

cat <<HTML

<!DOCTYPE html>
<html>
<head>
    <style type='text/css'>
        $STYLE
    </style>
    <title>Sysinfo</title>
    <meta charset='utf-8'>
</head>
<body>
    <h1>Load Average:</h1>
    <p class='loadavg'><b>$LoadAvg</b> (Ядер в системе: <b>$Cores</b>)</p>
    <h1>Memory using:</h1>
    <table class='df'><tbody>
        $(df -h | format)
    </tbody></table>
    <h1>История:</h1>
    <table class='history'><tbody>
        $(ls -ult /var/www/cgi-bin/history | tail -n+2 | awk '{print "<tr><td>"$6" "$7" "$8"</td><td><a href=\"/sysinfo/history/"$9"\">"$9"</a></td></tr>"}')
    </tbody></table>
</body>
</html>


HTML
