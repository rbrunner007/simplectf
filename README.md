# SimpleCTF

A single-script CTF scoreboard for Red vs Blue engagements 

## How to Use

1. Navigate to the `flags/` directory. There is a file for each team, named `red.txt` and `blue.txt`.
2. Put the flags for each team in their respective files, one flag per line.
3. Run `perl simplectf.pl`.
4. Go to (http://localhost:8080/scoreboard)[http://localhost:8080/scoreboard] to see the current score. 
5. The team names provide links to the flag submission page for that team. Click on your team and go get those flags!

Note: Because this is a 'simple' CTF, the server will remove flags from the flag files as they are submitted to prevent duplicate submissions. Make sure you keep a backup of your flag file if you don't want to lose your flags!