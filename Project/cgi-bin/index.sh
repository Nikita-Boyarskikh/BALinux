#!/bin/bash
echo "Content-Type: text/html"
echo

format() {
    cat | awk '{print "<tr>"; for(i=1;i<=NF;i++){print "<td>"$i"</td>"} print "</tr>"}'
}

cat <<HTML

<!DOCTYPE html>
<html>
<head>
    <title>Sysinfo</title>
</head>
<body>
    <table><tbody>
        $(ps ax | format)
    </tbody></table>
</body>
</html>

HTML
