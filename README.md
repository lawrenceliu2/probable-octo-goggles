<h1>Team Snakes Byte</h1>

<h2>Project: Multiplayer Snakes Stuffs with Networking</h2>

<h2>Development Log</h2>

<b>5/14/16</b>

- DAN: Wrote base snake game

<b>5/15/16</b>

- DAN: Wrote simple network framework with server and client

<b>5/16/16</b>

-Bug: On school computers, the game flashes the game over screen and the snake is unmovable, even though commands are being entered. Client also not connected to server (Daniel managed to actually move his snake but the game over screen persists) Same on Lawrence's computer but game over screen disappears.

-Bug report: The first time Lawrence opened the server and client, said bug occured. However, after restarting both, the game played as usual with no bugs. After restarting yet again, the bug appeared.

-Server should relay information based on number of clients now.

- DAN: Made a ghost snake to test server sided steering. It works

- DAN: Also fixed assignment of -1 ID's

<b>5/17/16</b>

-

<b>5/18/16</b>

-Server now relays more useful information such as how many snakes are connected, color of each, and how they are moving.

<b>5/19/16</b>

-Tweaked server text, color should be correctly displaying, snake text before starting the game will always be white.

-New bug: Whenever the snake dies or at random times, the text displayed will be more than one line and flicker, purely graphical glitch.

<b>5/20/16</b>

-

<b>5/21/16</b>

-

<b>5/22/16</b>

-More server text tweaking, flashing text should not occur for only one player.

-Next server update: Change text after player eats an apple.

<b>5/23/16</b>

-

<b>5/24/16</b>

- Demo Day!!!

<b>5/25/16</b>

- Demo Day!!!

- Wrote some code to make the apple spawning server sided. Need to figure out how to get the server output not to be null so the coordinates can be established.

<b>5/26/16</b>

- Apples are now server sided, determined by the server and appear in the same place for every client. (Tested)

- Cleaned code and added a couple comments, easier to understand.

- Slowed game speed.

- Play Again button now restarts the game, mostly just for easier debugging (don't have to stop and start again).

<b>5/27/16</b>

- Bug: Randomly, immediately after eating an apple, the snake will die. Potentially because of the delay 

- Made intro screen for client prettier.

<b>5/28/16</b>

-

<b>5/29/16</b>

-

<b>5/30/16</b>

-

<b>5/31/16</b>

- Added walls to the gameplay screen, may fix up graphically later.

<b>6/1/16</b>

-

<b>6/2/16</b>

-

<b>6/3/16</b>

- Added text on client to show user's color.

- Slight ID fix for controlling your snake.

<b>6/4/16</b>

-

<b>6/5/16</b>

- Attempted to fix the hellish ID issue. No fix but some progress??

<b>6/6/16</b>

- Bug Fix??? The random death after eating an apple seems to be fixed... Skpetical because it didn't happen after a lot of tests at home but happened often on school computers. Maybe the code I wrote did affect it? It shouldn't have though...

- Should no longer (or rarely) crash the game because of the server sending multiple messages.

- Singleplayer works 99% of the time (unless server messes up and sends messages partially/combined?)

- Snakes server based and game continues until all are dead.

- Bug: I lied up there^^^ it is confirmed that the client moves the apple correctly but for some reason crashes... Death should not occur, as the snake is not past a wall, but it does so anyways.

<b>6/7/16</b>

- Final Demo!!!!!
