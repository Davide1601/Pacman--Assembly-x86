TITLE Pacman 2.0, Chris Cullati Bryan Quinlan, November 5, 2013				(main.asm)

; 
; 
; 
; 
; Revision date:

INCLUDE Irvine32.inc
INCLUDE mCheckRow.txt
INCLUDE C:\masm32\include\kernel32.inc
INCLUDE C:\masm32\include\user32.inc

.data

;This is for mouse clicks
POINT STRUCT
x DWORD ?
y DWORD ?
POINT ENDS
MOUSE	POINT	<>  ;mouse coordinates will be saved as MOUSE.X and MOUSE.Y, literally use "Mouse.X" and "Mouse.Y" when you need those values
hwnd DWORD ?

;Prints title
bigTitle1 db "   #######      ##         ######         #        #      ##      ##   ###", 0
bigTitle2 db "   ### ###     ####       ########        ##      ##     ####     ###  ###", 0
bigTitle3 db "   #######    ######     #######    ####  ####  ####    ######    #### ###", 0
bigTitle4 db "   ###       ###  ###    #######    ####  ##########   ###  ###   ########", 0
bigTitle5 db "   ###      ##########    ########        ##########  ##########  ########", 0
bigTitle6 db "   ###     ############    ######         ########## ############ ########", 0

bigPacman1 db  "         ######      ", 0
bigPacman2 db  "       ##########    ", 0
bigPacman3 db  "     ##############  ", 0
bigPacman4 db  "    ########## ##### ", 0
bigPacman5 db  "   ##################", 0
bigPacman6 db  "  #################  ", 0
bigPacman7 db  " ###############     ", 0
bigPacman8 db  " ############        ", 0
bigPacman9 db  " ############        ", 0
bigPacman10 db " ###############     ", 0
bigPacman11 db "  #################  ", 0
bigPacman12 db "   ##################", 0
bigPacman13 db "    ################ ", 0
bigPacman14 db "     ##############  ", 0
bigPacman15 db "       ##########    ", 0
bigPacman16 db "         ######      ", 0

bigDot1 db " ## ", 0
bigDot2 db "####", 0
bigDot3 db "####", 0
bigDot4 db " ## ", 0

emptyString db "                            ", 0

newGamePrompt db "New Game", 0
controlsPrompt db "Controls", 0
howToPlayPrompt db "How to Play", 0
exitPrompt db "Exit", 0
menuChoice db ?

congrats db "Congratulations ", 0
playerNamePrompt db "Enter Name: ", 0
playerName db 20 DUP (0)
scoremsg db " your score was ", 0

controlsTitle db "Controls", 0
lines db "___________", 0
wButton db "w : Moves Pacman up 1 space", 0
aButton db "a : Moves Pacman left 1 space", 0
sButton db "s : Moves Pacman down 1 space", 0
dButton db "d : Moves Pacman right 1 space", 0
pButton db "p : Pauses game until p is pressed again (shows How To Play Screen)", 0
hButton db "h : Shows controls until h is pressed again", 0
qButton db "q : Quits game", 0
goBackButton db "Go Back", 0
goBackCheck db 0
HowToPlayTitle db "How To Play", 0
objective1 db "The objective is to collect all the pellets( . ) without getting ", 0
objective2 db "caught by the ghosts.", 0 
objective3 db "Each pellet gives you 100 points and power pellets( * ) give you 50 points.", 0
objective4 db "A fruit( % ) will randomly appear which gives 100 points.", 0
objective5 db "Once you get 10,000 points a free life will be awarded.", 0
objective6 db "The power pellets freeze the ghosts for a short amount of time.", 0
objective7 db "If you get caught by the ghosts, you will lose a life and go ", 0
objective8 db "back to the starting position.", 0
objective9 db "In the middle of the map on the left and right there are open spaces.", 0
objective10 db "Going out the left side brings you in on the right side and vice versa.", 0

;Champ variables
champ_x	BYTE 23						;Pacman's x coordinate on the console
champ_xnew BYTE 23					;when a direction is pressed, champ_xnew holds the x coordinate pacman is trying to enter
champ_y BYTE 14						;Pacman's y coordinate
champ_ynew BYTE 14					;Champ_xnew : x coordinate :: champ_ynew : y coordinate (thats an analogy)
champ BYTE '<'						;Represents pacman (initially facing right)
char BYTE ?							;A placeholder variable
lives BYTE 3						;Represents Pacman's remaining lives
powermode BYTE 0					;Boolean, 1 means powermode on, 0 means off
powercount BYTE 0					;How many updates left until powermode ends
POWER_MAX db 100					;Max powermode time, decreases as level increases
dots BYTE 0							;How many dots pacman has eaten this level, bonus fruit is dependent on this
level db 1							;Represents what Level you are on
bonus dw 0							;how much the bonus is worth
hasbonuslife db 0					;boolean for having bonus life or not

helpme db 0
pauseme db 0						;Basically a boolean, 1 means game is paused, 0 means game is unpaused
pausescreen_msg BYTE "**PAUSED**", 0
endScreen db "End of Game, Thanks for playing!", 0
bye db "Goodbye!", 0

score WORD 0						;Player's score
scoreMod WORD 10					;The number by which score is incremented
score_msg BYTE "Score: ",0			;Message for outputting score
level_msg BYTE "Level: ",0
lives_msg BYTE "Lives: ",0			;I'd like to implement this differently, with the lives indicatd by little pacmen at the bottom, but for now this works

mapwdots0 BYTE	"############################", 0
mapwdots1 BYTE	"#............##............#", 0
mapwdots2 BYTE	"#.####.#####.##.#####.####.#", 0
mapwdots3 BYTE	"#*#  #.#   #.##.#   #.#  #*#", 0
mapwdots4 BYTE	"#.####.#####.##.#####.####.#", 0
mapwdots5 BYTE	"#..........................#", 0
mapwdots6 BYTE	"#.####.##.########.##.####.#", 0
mapwdots7 BYTE	"#.####.##.########.##.####.#", 0
mapwdots8 BYTE	"#......##....##....##......#", 0
mapwdots9 BYTE	"######.##### ## #####.######", 0
mapwdots10 BYTE	"     #.##### ## #####.#     ", 0
mapwdots11 BYTE	"     #.##    @     ##.#     ", 0
mapwdots12 BYTE	"     #.## ###--### ##.#     ", 0
mapwdots13 BYTE	"######.## #      # ##.######", 0
mapwdots14 BYTE	"      .   #      #   .      ", 0
mapwdots15 BYTE	"######.## # @ @ @# ##.######", 0
mapwdots16 BYTE	"     #.## ######## ##.#     ", 0
mapwdots17 BYTE	"     #.##          ##.#     ", 0
mapwdots18 BYTE	"     #.## ######## ##.#     ", 0
mapwdots19 BYTE	"######.## ######## ##.######", 0
mapwdots20 BYTE	"#............##............#", 0
mapwdots21 BYTE	"#.####.#####.##.#####.####.#", 0
mapwdots22 BYTE	"#.####.#####.##.#####.####.#", 0
mapwdots23 BYTE	"#*..##........ .......##..*#", 0
mapwdots24 BYTE	"###.##.##.########.##.##.###", 0
mapwdots25 BYTE	"###.##.##.########.##.##.###", 0
mapwdots26 BYTE	"#......##....##....##......#", 0
mapwdots27 BYTE	"#.##########.##.##########.#", 0
mapwdots28 BYTE	"#.##########.##.##########.#", 0
mapwdots29 BYTE "#..........................#", 0
mapwdots30 BYTE	"############################", 0


.code

main PROC
	StartGame:
		call PrintTitleScreen
		jmp PlayorExit

	ClearIt:
		call Clrscr
		jmp Update

	PlayorExit:
		cmp menuchoice, 1
		je PlayerNameMenu
		call Clrscr
		cmp menuChoice, 4
		je exitron
		jmp StartGame

	PlayerNameMenu:
		call getPlayerName
		call Clrscr
		jmp Update

	Update:
		call UpdateChamp					;Update function, checks keys and alters rest of program appropriately
		cmp champ_X, -1						;Check if q was pressed (quits if so)
		je exitron
		cmp pauseme, 1						;check if p was pressed (pauses if so)
		je isPaused
		cmp helpme, 1
		je isHelp
		call CheckMove						;runs proc to see if new move generated by UpdateChamp is legal, allows if legal, disallows if illegal
		call PrintMapWithDots				;prints the map
		call WriteChamp						;prints Pacman
		call CheckDots						;checks stuff related to score and drawing of bonus fruit
		GoCoords 31, 0
		mov edx, OFFSET level_msg			;level output on the side of the game
		call WriteString
		mov al, level
		call WriteDec
		GoCoords 31, 1
		mov edx, OFFSET lives_msg			;lives output on side
		call WriteString
		mov al, lives
		call WriteDec
		GoCoords 31, 2
		mov edx, OFFSET score_msg			;score output on side
		call WriteString
		mov ax, score
		call WriteDec
		call CheckScore						;checks to see whether or not bonus life should be added
		mov al, champ_x						;super important
		mov bl, champ_y						;Sets champ_x/ynew
		mov champ_xnew, al					;to champ_x/y
		mov champ_ynew, bl					;without this, one could keep pressing left against a wall until new_y = a legal value then pac would teleport there
		mov eax, 200						;after testing, delay of 200 seems to work best with regards to screen flicker and FPS
		call Delay
		jmp Update							;infinite loop unless quit or pause (really just quit)

	isPaused:
		call Clrscr
		cmp pauseme, 1
		je paused
		
	paused:									;jumps here when paused to loop until unpaused
		call UpdatePause					;check basically just to see if pause has been pressed again
		call PauseScreen					;display pause screen
		cmp pauseme, 0						;check pause value
		je ClearIt
		jne paused

	isHelp:
		call Clrscr
		cmp helpme, 1
		je Help

	help:
		call UpdateHelp
		call HelpScreen
		cmp helpme, 0
		je ClearIt
		jne help

	exitron:								;end of program. This is where we will implement game over screens, highscores, and any other extras. also additional levels
		call QuitScreen
		exit

main ENDP

getPlayerName PROC
	goCoords 0, 12
	mov edx, OFFSET emptyString
	call WriteString

	goCoords 0, 14
	mov edx, OFFSET emptyString
	call WriteString

	GoCoords 0, 16
	mov edx, OFFSET emptyString
	call WriteString

	GoCoords 0, 18
	mov edx, OFFSET emptyString
	call WriteString

	goCoords 3, 15
	mov edx, OFFSET playerNamePrompt
	call WriteString

	mov edx, OFFSET playerName
	mov ecx, SIZEOF playerName
	call ReadString

	RET
getPlayerName ENDP

PrintTitleScreen PROC

	;Prints Title "Pacman"

	mov eax, 14
	call SetTextColor
	GoCoords 0, 3
	mov edx, OFFSET bigTitle1
	call WriteString
	GoCoords 0, 4
	mov edx, OFFSET bigTitle2
	call WriteString
	GoCoords 0, 5
	mov edx, OFFSET bigTitle3
	call WriteString
	GoCoords 0, 6
	mov edx, OFFSET bigTitle4
	call WriteString
	GoCoords 0, 7
	mov edx, OFFSET bigTitle5
	call WriteString
	GoCoords 0, 8
	mov edx, OFFSET bigTitle6
	call WriteString

	;Prints big pacman

	GoCoords 36, 13
	mov edx, OFFSET bigPacman1
	call WriteString
	GoCoords 36, 14
	mov edx, OFFSET bigPacman2
	call WriteString
	GoCoords 36, 15
	mov edx, OFFSET bigPacman3
	call WriteString
	GoCoords 36, 16
	mov edx, OFFSET bigPacman4
	call WriteString
	GoCoords 36, 17
	mov edx, OFFSET bigPacman5
	call WriteString
	GoCoords 36, 18
	mov edx, OFFSET bigPacman6
	call WriteString
	GoCoords 36, 19
	mov edx, OFFSET bigPacman7
	call WriteString
	GoCoords 36, 20
	mov edx, OFFSET bigPacman8
	call WriteString
	GoCoords 36, 21
	mov edx, OFFSET bigPacman9
	call WriteString
	GoCoords 36, 22
	mov edx, OFFSET bigPacman10
	call WriteString
	GoCoords 36, 23
	mov edx, OFFSET bigPacman11
	call WriteString
	GoCoords 36, 24
	mov edx, OFFSET bigPacman12
	call WriteString
	GoCoords 36, 25
	mov edx, OFFSET bigPacman13
	call WriteString
	GoCoords 36, 26
	mov edx, OFFSET bigPacman14
	call WriteString
	GoCoords 36, 27
	mov edx, OFFSET bigPacman15
	call WriteString
	GoCoords 36, 28
	mov edx, OFFSET bigPacman16
	call WriteString

	;Prints big dot

	colorWhite
	GoCoords 58, 19
	mov edx, OFFSET bigDot1
	call WriteString
	GoCoords 58, 20
	mov edx, OFFSET bigDot2
	call WriteString
	GoCoords 58, 21
	mov edx, OFFSET bigDot3
	call WriteString
	GoCoords 58, 22
	mov edx, OFFSET bigDot4
	call WriteString

	GoCoords 12, 12
	mov edx, OFFSET newGamePrompt
	call WriteString

	GoCoords 12, 14
	mov edx, OFFSET controlsPrompt
	call WriteString

	GoCoords 12, 16
	mov edx, OFFSET howToPlayPrompt
	call WriteString


	GoCoords 12, 18
	mov edx, OFFSET exitPrompt
	call WriteString

	call MenuItemChoice

	RET
PrintTitleScreen ENDP

MenuItemChoice PROC
	.REPEAT
		call GetMouseCoords

		CheckNewGameXCoordLower:
			cmp MOUSE.X, 88
			jge CheckNewGameXCoordUpper
			jmp CheckControlsXCoordLower

		CheckNewGameXCoordUpper:
			cmp MOUSE.X, 163
			jle CheckNewGameYCoordLower
			jmp CheckControlsXCoordLower

		CheckNewGameYCoordLower:
			cmp MOUSE.Y, 138
			jge CheckNewGameYCoordUpper
			jmp CheckControlsXCoordLower

		CheckNewGameYCoordUpper:
			cmp MOUSE.Y, 156
			jle PlayGame
			jmp CheckControlsXCoordLower

		CheckControlsXCoordLower:
			cmp MOUSE.X, 88
			jge CheckControlsXCoordUpper
			jmp CheckHowToPlayXCoordsLower

		CheckControlsXCoordUpper:
			cmp MOUSE.X, 163
			jle CheckControlsYCoordLower
			jmp CheckHowToPlayXCoordsLower

		CheckControlsYCoordLower:
			cmp MOUSE.Y, 165
			jge CheckControlsYCoordUpper
			jmp CheckHowToPlayXCoordsLower

		CheckControlsYCoordUpper:
			cmp MOUSE.Y, 179
			jle Controls
			jmp CheckHowToPlayXCoordsLower

		CheckHowToPlayXCoordsLower:
			cmp MOUSE.X, 88
			jge CheckHowToPlayXCoordsUpper
			jmp CheckExitXCoordsLower

		CheckHowToPlayXCoordsUpper:
			cmp MOUSE.X, 187
			jle CheckHowToPlayYCoordsLower
			jmp CheckExitXCoordsLower

		CheckHowToPlayYCoordsLower:
			cmp MOUSE.Y, 189
			jge CheckHowToPlayYCoordsUpper
			jmp CheckExitXCoordsLower

		CheckHowToPlayYCoordsUpper:
			cmp MOUSE.Y, 204
			jle HowToPlay
			jmp CheckExitXCoordsLower

		CheckExitXCoordsLower:
			cmp MOUSE.X, 88
			jge CheckExitXCoordsUpper
			jmp EndMenuItemChoice

		CheckExitXCoordsUpper:
			cmp MOUSE.X, 133
			jle CheckExitYCoordsLower
			jmp EndMenuItemChoice

		CheckExitYCoordsLower:
			cmp MOUSE.Y, 213
			jge CheckExitYCoordsUpper
			jmp EndMenuItemChoice

		CheckExitYCoordsUpper:
			cmp MOUSE.Y, 230
			jle ExitGame
			jmp EndMenuItemChoice

		PlayGame:
			mov menuChoice, 1
			jmp EndMenuItemChoice

		Controls:
			call DisplayControls
			mov menuChoice, 2
			jmp EndMenuItemChoice

		HowToPlay:
			call DisplayHowToPlayMenu
			mov menuChoice, 3
			jmp EndMenuItemChoice

		ExitGame:
			mov menuChoice, 4
			jmp EndMenuItemChoice

		EndMenuItemChoice:
	.UNTIL(MenuChoice>0) ;Repeats until New Game, Controls, How To Play, or Exit is clicked

	GoCoords 0, 20
	RET
MenuItemChoice ENDP

DisplayControls PROC
	call ClrScr
	call HelpScreen

	GoCoords 38, 26
	mov edx, OFFSET goBackButton
	call WriteString
	.REPEAT
		call GoBack
	.UNTIL (goBackCheck>0) 
	call Clrscr
	RET
DisplayControls ENDP

GoBack PROC
	mov goBackCheck, 0

	call GetMouseCoords

	GoBackXCoordLower:
		cmp MOUSE.X, 297
		jge GoBackXCoordUpper
		jmp  CheckGoBackLoop

	GoBackXCoordUpper:
		cmp MOUSE.X, 367
		jle GoBackYCoordLower
		jmp CheckGoBackLoop

	GoBackYCoordLower:
		cmp MOUSE.Y,305
		jge GoBackYCoordUpper
		jmp CheckGoBackLoop

	GoBackYCoordUpper:
		cmp MOUSE.Y, 326
		jle IncGoBack
		jmp CheckGoBackLoop

	IncGoBack:
		mov goBackCheck, 1

	CheckGoBackLoop:

	RET
GoBack ENDP

DisplayHowToPlayMenu PROC
	call Clrscr

	GoCoords 34, 3
	mov edx, OFFSET howToPlayTitle
	call WriteString
	GoCoords 34, 4
	mov edx, OFFSET lines
	call WriteString

	call PauseScreen

	GoCoords 38, 26
	mov edx, OFFSET goBackButton
	call WriteString
	.REPEAT
		call GoBack
	.UNTIL (goBackCheck>0) 
	call Clrscr
	RET
DisplayHowToPlayMenu ENDP

GetMouseCoords PROC
mov ebx, 0
.REPEAT
	invoke GetKeyState, VK_LBUTTON   ;waits for you to click somewhere
    .if sbyte ptr ah<0
	   mov ebx, 1
	.ENDIF
.UNTIL(ebx==1) ;when you do click somewhere it gets the mouse coordinates of where you clicked
	INVOKE	GetCursorPos, ADDR MOUSE
	Call GetConsoleWindow
	mov hwnd, eax
	INVOKE ScreenToClient, hwnd, ADDR MOUSE
ret
GetMouseCoords ENDP

PrintMapWithDots PROC

GoCoords 0, 0

;Print row 0

colorBlue
mov edx, OFFSET mapwdots0
call WriteString

;Print row 1

mov esi, 0

GoCoords 0, 1
PrintCharInc mapwdots1

colorWhite

LoopRow11:
	PrintMapLoop mapwdots1, 13
	jl LoopRow11

colorBlue

LoopRow12:
	PrintMapLoop mapwdots1, 15
	jl LoopRow12

colorWhite

LoopRow13:
	PrintMapLoop mapwdots1, 27
	jl LoopRow13

colorBlue
PrintCharInc mapwdots1

;Print row 2

mov esi, 0

GoCoords 0, 2
PrintCharInc mapwdots2
colorWhite
PrintCharInc mapwdots2
colorBlue

LoopRow21:
	PrintMapLoop mapwdots2, 6
	jl LoopRow21

colorWhite
PrintCharInc mapwdots2
colorBlue

LoopRow22:
	PrintMapLoop mapwdots2, 12
	jl LoopRow22

colorWhite
PrintCharInc mapwdots2
colorBlue

LoopRow23:
	PrintMapLoop mapwdots2, 15
	jl LoopRow23

colorWhite
PrintCharInc mapwdots2
colorBlue

LoopRow24:
	PrintMapLoop mapwdots2, 21
	jl LoopRow24

colorWhite
PrintCharInc mapwdots2
colorBlue

LoopRow25:
	PrintMapLoop mapwdots2, 26
	jl LoopRow25

colorWhite
PrintCharInc mapwdots2
colorBlue
PrintCharInc mapwdots2

;Print row 3

mov esi, 0

GoCoords 0, 3
PrintCharInc mapwdots3
colorWhite
PrintCharInc mapwdots3
colorBlue

LoopRow31:
	PrintMapLoop mapwdots3, 6
	jl LoopRow31

colorWhite
PrintCharInc mapwdots3
colorBlue

LoopRow32:
	PrintMapLoop mapwdots3, 12
	jl LoopRow32

colorWhite
PrintCharInc mapwdots3
colorBlue

LoopRow33:
	PrintMapLoop mapwdots3, 15
	jl LoopRow33

colorWhite
PrintCharInc mapwdots3
colorBlue

LoopRow34:
	PrintMapLoop mapwdots3, 21
	jl LoopRow34

colorWhite
PrintCharInc mapwdots3
colorBlue

LoopRow35:
	PrintMapLoop mapwdots3, 26
	jl LoopRow35

colorWhite
PrintCharInc mapwdots3
colorBlue
PrintCharInc mapwdots3


;Print row 4

mov esi, 0

GoCoords 0, 4
PrintCharInc mapwdots4
colorWhite
PrintCharInc mapwdots4
colorBlue

LoopRow41:
	PrintMapLoop mapwdots4, 6
	jl LoopRow41

colorWhite
PrintCharInc mapwdots4
colorBlue

LoopRow42:
	PrintMapLoop mapwdots4, 12
	jl LoopRow42

colorWhite
PrintCharInc mapwdots4
colorBlue

LoopRow43:
	PrintMapLoop mapwdots4, 15
	jl LoopRow43

colorWhite
PrintCharInc mapwdots4
colorBlue

LoopRow44:
	PrintMapLoop mapwdots4, 21
	jl LoopRow44

colorWhite
PrintCharInc mapwdots4
colorBlue

LoopRow45:
	PrintMapLoop mapwdots4, 26
	jl LoopRow45

colorWhite
PrintCharInc mapwdots4
colorBlue
PrintCharInc mapwdots4

;Print row 5

mov esi, 0

GoCoords 0, 5
PrintCharInc mapwdots5
colorWhite

LoopRow51:
	PrintMapLoop mapwdots5, 27
	jl LoopRow51

colorBlue
PrintCharInc mapwdots5

;Print row 6

mov esi, 0

GoCoords 0, 6
PrintCharInc mapwdots6
colorWhite
PrintCharInc mapwdots6
colorBlue

LoopRow61:
	PrintMapLoop mapwdots6, 6
	jl LoopRow61

colorWhite
PrintCharInc mapwdots6
colorBlue

Loop62:
	PrintMapLoop mapwdots6, 9
	jl Loop62

colorWhite
PrintCharInc mapwdots6
colorBlue

LoopRow63:
	PrintMapLoop mapwdots6, 18
	jl LoopRow63

colorWhite
PrintCharInc mapwdots6
colorBlue

LoopRow64:
	PrintMapLoop mapwdots6, 21
	jl LoopRow64

colorWhite
PrintCharInc mapwdots6
colorBlue

LoopRow65:
	PrintMapLoop mapwdots6, 26
	jl LoopRow65

colorWhite
PrintCharInc mapwdots6
colorBlue
PrintCharInc mapwdots6

;Print row 7

mov esi, 0
GoCoords 0, 7
PrintCharInc mapwdots7
colorWhite
PrintCharInc mapwdots7
colorBlue

LoopRow71:
	PrintMapLoop mapwdots7, 6
	jl LoopRow71

colorWhite
PrintCharInc mapwdots7
colorBlue

Loop72:
	PrintMapLoop mapwdots7, 9
	jl Loop72

colorWhite
PrintCharInc mapwdots7
colorBlue

LoopRow73:
	PrintMapLoop mapwdots7, 18
	jl LoopRow73

colorWhite
PrintCharInc mapwdots7
colorBlue

LoopRow74:
	PrintMapLoop mapwdots7, 21
	jl LoopRow74

colorWhite
PrintCharInc mapwdots7
colorBlue

LoopRow75:
	PrintMapLoop mapwdots7, 26
	jl LoopRow75

colorWhite
PrintCharInc mapwdots7
colorBlue
PrintCharInc mapwdots7

;Print row 8

mov esi, 0

GoCoords 0, 8
PrintCharInc mapwdots8
colorWhite

LoopRow81:
	PrintMapLoop mapwdots8, 7
	jl LoopRow81

colorBlue

LoopRow82:
	PrintMapLoop mapwdots9, 9
	jl LoopRow82

colorWhite

LoopRow83:
	PrintMapLoop mapwdots8, 13
	jl LoopRow83

colorBlue

LoopRow84:
	PrintMapLoop mapwdots8, 15
	jl LoopRow84

colorWhite

LoopRow85:
	PrintMapLoop mapwdots8, 19
	jl LoopRow85

colorBlue

LoopRow86:
	PrintMapLoop mapwdots8, 21
	jl LoopRow86

colorWhite

LoopRow87:
	PrintMapLoop mapwdots8, 27
	jl LoopRow87

colorBlue
PrintCharInc mapwdots8

;Print row 9

mov esi, 0

GoCoords 0, 9
LoopRow91:
	PrintMapLoop mapwdots9, 6
	jl LoopRow91

colorWhite
PrintCharInc mapwdots9
colorBlue

LoopRow92:
	PrintMapLoop mapwdots9, 21
	jl LoopRow92

colorWhite
PrintCharInc mapwdots9
colorBlue

LoopRow93:
	PrintMapLoop mapwdots9, 28
	jl LoopRow93

;Print row 10

mov esi, 0

GoCoords 0, 10
LoopRow101:
	PrintMapLoop mapwdots10, 6
	jl LoopRow101

colorWhite
PrintCharInc mapwdots10
colorBlue

LoopRow102:
	PrintMapLoop mapwdots10, 21
	jl LoopRow102

colorWhite
PrintCharInc mapwdots10
colorBlue

LoopRow103:
	PrintMapLoop mapwdots10, 28
	jl LoopRow103


;Print row 11

mov esi, 0

GoCoords 0, 11
LoopRow111:
	PrintMapLoop mapwdots11, 6
	jl LoopRow111

colorWhite
PrintCharInc mapwdots11
colorBlue

LoopRow112:
	PrintMapLoop mapwdots11, 13
	jl LoopRow112

mov eax, 12
call SetTextColor

LoopRow113:
	PrintMapLoop mapwdots11, 15
	jl LoopRow113

colorBlue

LoopRow114:
	PrintMapLoop mapwdots11, 21
	jl LoopRow114

colorWhite
PrintCharInc mapwdots11
colorBlue

LoopRow115:
	PrintMapLoop mapwdots11, 28
	jl LoopRow115

;Print row 12

mov esi, 0

GoCoords 0, 12
LoopRow121:
	PrintMapLoop mapwdots12, 6
	jl LoopRow121

colorWhite
PrintCharInc mapwdots12
colorBlue

LoopRow122:
	PrintMapLoop mapwdots12, 13
	jl LoopRow122

mov eax, 5
call SetTextColor

LoopRow123:
	PrintMapLoop mapwdots12, 15
	jl LoopRow123

colorBlue

LoopRow124:
	PrintMapLoop mapwdots12, 21
	jl LoopRow124

colorWhite
PrintCharInc mapwdots12
colorBlue

LoopRow125:
	PrintMapLoop mapwdots12, 28
	jl LoopRow125

;Print row 13

mov esi, 0

GoCoords 0, 13
LoopRow131:
	PrintMapLoop mapwdots13, 6
	jl LoopRow131

colorWhite
PrintCharInc mapwdots13

colorBlue

LoopRow132:
	PrintMapLoop mapwdots13, 21
	jl LoopRow132

colorWhite
PrintCharInc mapwdots13
colorBlue

LoopRow133:
	PrintMapLoop mapwdots13, 28
	jl LoopRow133

;Print row 14

mov esi, 0

GoCoords 0, 14
LoopRow141:
	PrintMapLoop mapwdots14, 6
	jl LoopRow141

colorWhite
PrintCharInc mapwdots14

colorBlue

LoopRow142:
	PrintMapLoop mapwdots14, 21
	jl LoopRow142

colorWhite
PrintCharInc mapwdots14
colorBlue

LoopRow143:
	PrintMapLoop mapwdots14, 28
	jl LoopRow143

;Print row 15

mov esi, 0

GoCoords 0, 15
LoopRow151:
	PrintMapLoop mapwdots15, 6
	jl LoopRow151

colorWhite
PrintCharInc mapwdots15

colorBlue

LoopRow152:
	PrintMapLoop mapwdots15, 12
	jl LoopRow152

mov eax, 11
call SetTextColor

LoopRow153:
	PrintMapLoop mapwdots15, 14
	jl LoopRow153

mov eax, 13
call SetTextColor

LoopRow154:
	PrintMapLoop mapwdots15, 16
	jl LoopRow154

mov eax, 10
call SetTextColor
PrintCharInc mapwdots15
colorBlue

LoopRow155:
	PrintMapLoop mapwdots15, 21
	jl LoopRow155

colorWhite
PrintCharInc mapwdots15
colorBlue

LoopRow156:
	PrintMapLoop mapwdots15, 28
	jl LoopRow156

;Print row 16

mov esi, 0

GoCoords 0, 16
LoopRow161:
	PrintMapLoop mapwdots16, 6
	jl LoopRow161

colorWhite
PrintCharInc mapwdots16

colorBlue

LoopRow162:
	PrintMapLoop mapwdots16, 21
	jl LoopRow162

colorWhite
PrintCharInc mapwdots16
colorBlue

LoopRow163:
	PrintMapLoop mapwdots16, 28
	jl LoopRow163

;Print row 17

mov esi, 0

GoCoords 0, 17
LoopRow171:
	PrintMapLoop mapwdots17, 6
	jl LoopRow171

colorWhite
PrintCharInc mapwdots17

colorBlue

LoopRow172:
	PrintMapLoop mapwdots17, 21
	jl LoopRow172

colorWhite
PrintCharInc mapwdots17
colorBlue

LoopRow173:
	PrintMapLoop mapwdots17, 28
	jl LoopRow173

;Print row 18

mov esi, 0

GoCoords 0, 18
LoopRow181:
	PrintMapLoop mapwdots18, 6
	jl LoopRow181

colorWhite
PrintCharInc mapwdots18

colorBlue

LoopRow182:
	PrintMapLoop mapwdots18, 21
	jl LoopRow182

colorWhite
PrintCharInc mapwdots18
colorBlue

LoopRow183:
	PrintMapLoop mapwdots18, 28
	jl LoopRow183

;Print row 19

mov esi, 0

GoCoords 0, 19
LoopRow191:
	PrintMapLoop mapwdots19, 6
	jl LoopRow191

colorWhite
PrintCharInc mapwdots19

colorBlue

LoopRow192:
	PrintMapLoop mapwdots18, 21
	jl LoopRow192

colorWhite
PrintCharInc mapwdots19
colorBlue

LoopRow193:
	PrintMapLoop mapwdots19, 28
	jl LoopRow193

;Print row 20

mov esi, 0

GoCoords 0, 20
PrintCharInc mapwdots20

colorWhite

LoopRow201:
	PrintMapLoop mapwdots20, 13
	jl LoopRow201

colorBlue

LoopRow202:
	PrintMapLoop mapwdots20, 15
	jl LoopRow202

colorWhite

LoopRow203:
	PrintMapLoop mapwdots20, 27
	jl LoopRow203

colorBlue
PrintCharInc mapwdots20

;Print row 21

mov esi, 0

GoCoords 0, 21
PrintCharInc mapwdots21
colorWhite
PrintCharInc mapwdots21
colorBlue

LoopRow211:
	PrintMapLoop mapwdots21, 6
	jl LoopRow211

colorWhite
PrintCharInc mapwdots21
colorBlue

LoopRow212:
	PrintMapLoop mapwdots21, 12
	jl LoopRow212

colorWhite
PrintCharInc mapwdots21
colorBlue

LoopRow213:
	PrintMapLoop mapwdots21, 15
	jl LoopRow213

colorWhite
PrintCharInc mapwdots21
colorBlue

LoopRow214:
	PrintMapLoop mapwdots21, 21
	jl LoopRow214

colorWhite
PrintCharInc mapwdots21
colorBlue

LoopRow215:
	PrintMapLoop mapwdots21, 26
	jl LoopRow215

colorWhite
PrintCharInc mapwdots21
colorBlue
PrintCharInc mapwdots21

;Print row 22

mov esi, 0

GoCoords 0, 22
PrintCharInc mapwdots22
colorWhite
PrintCharInc mapwdots22
colorBlue

LoopRow221:
	PrintMapLoop mapwdots22, 6
	jl LoopRow221

colorWhite
PrintCharInc mapwdots22
colorBlue

LoopRow222:
	PrintMapLoop mapwdots22, 12
	jl LoopRow222

colorWhite
PrintCharInc mapwdots22
colorBlue

LoopRow223:
	PrintMapLoop mapwdots22, 15
	jl LoopRow223

colorWhite
PrintCharInc mapwdots22
colorBlue

LoopRow224:
	PrintMapLoop mapwdots22, 21
	jl LoopRow224

colorWhite
PrintCharInc mapwdots22
colorBlue

LoopRow225:
	PrintMapLoop mapwdots22, 26
	jl LoopRow225

colorWhite
PrintCharInc mapwdots22
colorBlue
PrintCharInc mapwdots22

;Prints row 23

mov esi, 0

GoCoords 0, 23
PrintCharInc mapwdots23
colorWhite

LoopRow231:
	PrintMapLoop mapwdots23, 4
	jl LoopRow231

colorBlue

LoopRow232:
	PrintMapLoop mapwdots23, 6
	jl LoopRow232

colorWhite

LoopRow233:
	PrintMapLoop mapwdots23, 14
	jl LoopRow233

mov eax, 14
call SetTextColor
PrintCharInc mapwdots23
colorWhite

LoopRow234:
	PrintMapLoop mapwdots23, 22
	jl LoopRow234

colorBlue

LoopRow235:
	PrintMapLoop mapwdots23, 24
	jl LoopRow235

colorWhite

LoopRow236:
	PrintMapLoop mapwdots23, 27
	jl LoopRow236

colorBlue
PrintCharInc mapwdots23

;Print row 24

mov esi, 0

GoCoords 0, 24
LoopRow241:
	PrintMapLoop mapwdots24, 3
	jl LoopRow241

colorWhite
PrintCharInc mapwdots24
colorBlue

LoopRow242:
	PrintMapLoop mapwdots24, 6
	jl LoopRow242

colorWhite
PrintCharInc mapwdots24
colorBlue

LoopRow243:
	PrintMapLoop mapwdots24, 9
	jl LoopRow243

colorWhite
PrintCharInc mapwdots24
colorBlue

LoopRow244:
	PrintMapLoop mapwdots24, 18
	jl LoopRow244

colorWhite
PrintCharInc mapwdots24
colorBlue

LoopRow245:
	PrintMapLoop mapwdots24, 21
	jl LoopRow245

colorWhite
PrintCharInc mapwdots24
colorBlue

LoopRow246:
	PrintMapLoop mapwdots24, 24
	jl LoopRow246

colorWhite
PrintCharInc mapwdots24
colorBlue

LoopRow247:
	PrintMapLoop mapwdots24, 28
	jl LoopRow247

;Print row 25

mov esi, 0

GoCoords 0, 25
LoopRow251:
	PrintMapLoop mapwdots25, 3
	jl LoopRow251

colorWhite
PrintCharInc mapwdots25
colorBlue

LoopRow252:
	PrintMapLoop mapwdots25, 6
	jl LoopRow252

colorWhite
PrintCharInc mapwdots25
colorBlue

LoopRow253:
	PrintMapLoop mapwdots25, 9
	jl LoopRow253

colorWhite
PrintCharInc mapwdots25
colorBlue

LoopRow254:
	PrintMapLoop mapwdots25, 18
	jl LoopRow254

colorWhite
PrintCharInc mapwdots25
colorBlue

LoopRow255:
	PrintMapLoop mapwdots25, 21
	jl LoopRow255

colorWhite
PrintCharInc mapwdots25
colorBlue

LoopRow256:
	PrintMapLoop mapwdots25, 24
	jl LoopRow256

colorWhite
PrintCharInc mapwdots25
colorBlue

LoopRow257:
	PrintMapLoop mapwdots25, 28
	jl LoopRow257

;Print row 26

mov esi, 0

GoCoords 0, 26
PrintCharInc mapwdots26
colorWhite

LoopRow261:
	PrintMapLoop mapwdots26, 7
	jl LoopRow261

colorBlue

LoopRow262:
	PrintMapLoop mapwdots26, 9
	jl LoopRow262

colorWhite

LoopRow263:
	PrintMapLoop mapwdots26, 13
	jl LoopRow263

colorBlue

LoopRow264:
	PrintMapLoop mapwdots26, 15
	jl LoopRow264

colorWhite

LoopRow265:
	PrintMapLoop mapwdots26, 19
	jl LoopRow265

colorBlue

LoopRow266:
	PrintMapLoop mapwdots26, 21
	jl LoopRow266

colorWhite

LoopRow267:
	PrintMapLoop mapwdots26, 27
	jl LoopRow267

colorBlue
PrintCharInc mapwdots26

;Print row 27

mov esi, 0

GoCoords 0, 27
PrintCharInc mapwdots27
colorWhite
PrintCharInc mapwdots27
colorBlue

LoopRow271:
	PrintMapLoop mapwdots27, 12
	jl LoopRow271

colorWhite
PrintCharInc mapwdots27
colorBlue

LoopRow272:
	PrintMapLoop mapwdots27, 15
	jl LoopRow272

colorWhite
PrintCharInc mapwdots27
colorBlue

LoopRow273:
	PrintMapLoop mapwdots27, 26
	jl LoopRow273

colorWhite
PrintCharInc mapwdots27
colorBlue
PrintCharInc mapwdots27

;Print row 28

mov esi, 0

GoCoords 0, 28
PrintCharInc mapwdots28
colorWhite
PrintCharInc mapwdots28
colorBlue

LoopRow281:
	PrintMapLoop mapwdots28, 12
	jl LoopRow281

colorWhite
PrintCharInc mapwdots28
colorBlue

LoopRow282:
	PrintMapLoop mapwdots28, 15
	jl LoopRow282

colorWhite
PrintCharInc mapwdots28
colorBlue

LoopRow283:
	PrintMapLoop mapwdots28, 26
	jl LoopRow283

colorWhite
PrintCharInc mapwdots28
colorBlue
PrintCharInc mapwdots28

;Print row 29

mov esi, 0

GoCoords 0, 29
PrintCharInc mapwdots29
colorWhite

LoopRow291:
	PrintMapLoop mapwdots29, 27
	jl LoopRow291

colorBlue
PrintCharInc mapwdots29

;Print row 30

GoCoords 0, 30
colorBlue
mov edx, OFFSET mapwdots30
call WriteString
call Crlf

RET
PrintMapWithDots ENDP

UpdateChamp PROC
	call ReadKey			;readkey is in the irvine32 library and it performs a no-wait check to the state of the keyboard-
							; -and returns the ascii value of the key to ax, as well as the scancode to dx and one other, idk its in the book and I didn't use it
	jz skip					;Also it returns zero if there is no key pressed so just skip and rewrite the map/champ
	mov char, al


	;Quit (Q or q)
	cmp char, 81
	je quit_pressed
	cmp char, 113
	je quit_pressed

	;Help (H or h)
	cmp char, 72
	je help_pressed
	cmp char, 104
	je help_pressed

	;Pause (P or p)
	cmp char, 80
	je pause_pressed
	cmp char, 112
	je pause_pressed
	
	;left (A or a)
	cmp char, 97
	je left_pressed
	cmp char, 65
	je left_pressed

	;right (D or d)
	cmp char, 68
	je right_pressed
	cmp char, 100
	je right_pressed

	;up (W or w)
	cmp char, 87
	je up_pressed
	cmp char, 119
	je up_pressed

	;down (S or s)
	cmp char, 83
	je down_pressed
	cmp char, 115
	je down_pressed

	jmp skip

	left_pressed:
		dec champ_ynew
		mov champ, '>'						;changes pacman's "sprite" if he changes direction
		jmp skip
	right_pressed:
		inc champ_ynew
		mov champ, '<'
		jmp skip
	up_pressed:
		dec champ_xnew
		mov champ, 'v'
		jmp skip
	down_pressed:
		inc champ_xnew
		mov champ, '^'
		jmp skip
	quit_pressed:
		mov champ_x, -1
		jmp skip
	pause_pressed:
		cmp pauseme, 0
		je pauseit
		jne unpauseit
		pauseit:
			mov pauseme, 1
			jmp skip
		unpauseit:
			mov pauseme, 0
			jmp skip
	help_pressed:
		cmp helpme, 0
		je helpit
		jne unhelpit
		helpit:
			mov helpme, 1
			jmp skip
		unhelpit:
			mov helpme, 0
			jmp skip


	skip:
		ret
UpdateChamp ENDP

UpdatePause PROC
	call ReadKey
	mov char, al
	
	;Pause (P or p)
	cmp char, 80
	je Pause_pressed
	cmp char, 112
	je Pause_pressed
	
	jmp Skip

	Pause_pressed:
		cmp pauseme, 0
		je PauseIt
		jne UnpauseIt
		PauseIt:
			mov pauseme, 1
			jmp Skip
		UnpauseIt:
			mov pauseme, 0
			jmp Skip
	Skip:

	ret
UpdatePause ENDP

UpdateHelp PROC
	call ReadKey
	mov char, al
	
	;Help h or H
	cmp char, 72
	je Help_pressed
	cmp char, 104
	je Help_pressed
	
	jmp Skip1

	Help_pressed:
		cmp helpme, 0
		je HelpIt
		jne UnhelpIt
		HelpIt:
			mov helpme, 1
			jmp Skip1
		UnhelpIt:
			mov helpme, 0
			jmp Skip1
	Skip1:

	ret
UpdateHelp ENDP

WriteChamp PROC
	AND eax, 0
	AND edx, 0
	mov dh, champ_x
	mov dl, champ_y
	call GoToXY
	mov eax, 14
	call SetTextColor
	mov al, champ
	call WriteChar
	ret
WriteChamp ENDP

WheresChamp PROC				;Debug method, maybe re-enabled in Durga mode or something. Displays coordinates of pac as well as x/ynew in top left
	mov dx, 0
	call GoToXY
	AND eax, 0
	mov al, champ_x
	call WriteInt
	call CRLF
	mov al, champ_y
	call WriteInt
	call CRLF
	AND eax, 0
	mov al, champ_xnew
	call WriteInt
	call CRLF
	AND eax, 0
	mov al, champ_ynew
	call WriteInt
	call CRLF
	ret
WheresChamp ENDP

CheckMove PROC
	;check move happens between UpdateChamp and WriteChamp to see if pacman should be written to the new location or not.

	;I used a macro that accepts champ_y and the appropriate string to check (mapwdotsX, 0 <= X <= 30) that tests [mapwdotsX+champ_ynew] to see what character is there
	;more on that at implementation
	
	cmp champ_xnew, -1				;disallow negative values for champ_x
	jle skip
	cmp champ_ynew, -1				;if ynew is -1, test for special case tunnel on left
	jz testxleft
	cmp champ_xnew, 31				;champ_x cannot exceed 29
	jge skip
	cmp champ_ynew, 28				;if ynew is 28, test for special case tunnel on right
	jz testxright
	jg skip

	cmp champ_xnew, 10				;checks champ_xnew against 10 to jump over some checks to speed things up
	ja oneThird
	cmp champ_xnew, 20				;checks again to potentially skip 10 more checks
	ja twoThirds

	cmp champ_xnew, 0				;Big section of cmp-jcond pairs that tell the program what row pacman is in
	jz Row0
	cmp champ_xnew, 1
	jz Row1
	cmp champ_xnew, 2
	jz Row2
	cmp champ_xnew, 3
	jz Row3
	cmp champ_xnew, 4
	jz Row4
	cmp champ_xnew, 5
	jz Row5
	cmp champ_xnew, 6
	jz Row6
	cmp champ_xnew, 7
	jz Row7
	cmp champ_xnew, 8
	jz Row8
	cmp champ_xnew, 9
	jz Row9
	cmp champ_xnew, 10
	jz Row10
oneThird:
	cmp champ_xnew, 11
	jz Row11
	cmp champ_xnew, 12
	jz Row12
	cmp champ_xnew, 13
	jz Row13
	cmp champ_xnew, 14
	jz Row14
	cmp champ_xnew, 15
	jz Row15
	cmp champ_xnew, 16
	jz Row16
	cmp champ_xnew, 17
	jz Row17
	cmp champ_xnew, 18
	jz Row18
	cmp champ_xnew, 19
	jz Row19
	cmp champ_xnew, 20
	jz Row20
twoThirds:
	cmp champ_xnew, 21
	jz Row21
	cmp champ_xnew, 22
	jz Row22
	cmp champ_xnew, 23
	jz Row23
	cmp champ_xnew, 24
	jz Row24
	cmp champ_xnew, 25
	jz Row25
	cmp champ_xnew, 26
	jz Row26
	cmp champ_xnew, 27
	jz Row27
	cmp champ_xnew, 28
	jz Row28
	cmp champ_xnew, 29
	jz Row29
	cmp champ_xnew, 30
	jz Row30

;contents of mCheckrow:
	;the macro works by pasting the following code into the program in place of the line "mCheckrow champ_ynew, mapwdotsX, qX"

;mCheckrow MACRO champ_ynew, rowtocheck, loopname
	;mov esi, OFFSET rowtocheck				;;rowtocheck is replaced with "mapwdotsX"
	;inc champ_ynew							;;couldn't do "mov ecx, champ_ynew+1" so this was the next best thing
	;mov ecx, champ_ynew					;;this loops through the loop (champ_ynew+1) times, in order to get the value from esi for appropriate location
	;loopname:								;;loopname exists so that there is no overloading of the same label (because a macro is basically a big TEXTEQU)
	;	mov al, [esi]						;;get character from esi into al
	;	inc esi
	;LOOP loopname
	;dec champ_ynew							;;so as not to mess with actual move
	;cmp al, '#'							;;Walls are #
	;jz isWall
	;cmp al, '-'							;;Ghost-pen walls are walls too
	;jz isWall
	;cmp al, '.'							;;A period represents a pellet to eat for points
	;jz isPellet
	;cmp al, '*'							;;An asterisk represents a power pellet
	;jz isPowerPellet
	;cmp al, '@'							;;An @ represents a ghost. 2spooky4me
	;jz isGhost
	;cmp al, '%'							;;A % represents a bonus fruit
	;jz isBonus
	;jmp isntWall
;ENDM
	
	Row0:
		mCheckRow champ_ynew, mapwdots0, q0
	Row1:
		mCheckRow champ_ynew, mapwdots1, q1
	Row2:
		mCheckRow champ_ynew, mapwdots2, q2
	Row3:
		mCheckRow champ_ynew, mapwdots3, q3
	Row4:
		mCheckRow champ_ynew, mapwdots4, q4
	Row5:
		mCheckRow champ_ynew, mapwdots5, q5
	Row6:
		mCheckRow champ_ynew, mapwdots6, q6
	Row7:
		mCheckRow champ_ynew, mapwdots7, q7
	Row8:
		mCheckRow champ_ynew, mapwdots8, q8
	Row9:
		mCheckRow champ_ynew, mapwdots9, q9
	Row10:
		mCheckRow champ_ynew, mapwdots10, q10
	Row11:
		mCheckRow champ_ynew, mapwdots11, q11
	Row12:
		mCheckRow champ_ynew, mapwdots12, q12
	Row13:
		mCheckRow champ_ynew, mapwdots13, q13
	Row14:
		mCheckRow champ_ynew, mapwdots14, q14
	Row15:
		mCheckRow champ_ynew, mapwdots15, q15
	Row16:
		mCheckRow champ_ynew, mapwdots16, q16
	Row17:
		mCheckRow champ_ynew, mapwdots17, q17
	Row18:
		mCheckRow champ_ynew, mapwdots18, q18
	Row19:
		mCheckRow champ_ynew, mapwdots19, q19
	Row20:
		mCheckRow champ_ynew, mapwdots20, q20
	Row21:
		mCheckRow champ_ynew, mapwdots21, q21
	Row22:
		mCheckRow champ_ynew, mapwdots22, q22
	Row23:
		mCheckRow champ_ynew, mapwdots23, q23
	Row24:
		mCheckRow champ_ynew, mapwdots24, q24
	Row25:
		mCheckRow champ_ynew, mapwdots25, q25
	Row26:
		mCheckRow champ_ynew, mapwdots26, q26
	Row27:
		mCheckRow champ_ynew, mapwdots27, q27
	Row28:
		mCheckRow champ_ynew, mapwdots28, q28
	Row29:
		mCheckRow champ_ynew, mapwdots29, q29
	Row30:
		mCheckRow champ_ynew, mapwdots30, q30

	testxright:								;tests for special case tunnel on right side
		cmp champ_xnew, 14
		jnz skip
		mov champ_y, 0						;send pac to opposite side if in appropriate row
		jmp skip

	testxleft:								;tests for special case tunnel on left side
		cmp champ_xnew, 14
		jnz skip
		mov champ_y, 27						;send pac to opposite side again
		jmp skip

	isWall:									;these labels all catch jumps that come from mCheckRow
		jmp skip							;If a wall, then just skip and exit without changing champ_x/y

	isntWall:
		mov al, champ_xnew					;if not a wall, move is legal and thus champ_x = champ_xnew, champ_y = champ_ynew
		mov bl, champ_ynew
		mov champ_x, al
		mov champ_y, bl
		jmp skip

	isPellet:								;if pellet, then move is legal, x/y updated, '.' removed from string for that row, and score updated appropriately
		mov cl, ' '
		mov [esi-1], cl
		mov al, champ_xnew
		mov bl, champ_ynew
		mov champ_x, al
		mov champ_y, bl
		mov cx, scoreMod
		add score, cx
		inc dots
		jmp skip

	isPowerPellet:							;if Power Pellet, then move is legal, x/y updated, * replaced with ' ' in appropriate row.
		mov cl, ' '
		mov [esi-1], cl
		add score, 50
		mov al, champ_xnew
		mov bl, champ_ynew
		mov champ_x, al
		mov champ_y, bl
		cmp powermode, 0
		jz powerOn
		jnz powerAlreadyOn

		powerOn:
			mov powermode, 1
			mov bl, POWER_MAX
			mov powercount, bl
		powerAlreadyOn:
			mov bl, POWER_MAX
			mov powercount, bl
		jmp skip

	isGhost:
		;implement pacman death, lives--, score-something, and reset position after death screen
		;also potentially implement ghost eating cmp powermode, 1 jz killghost jnz killthepacman
		cmp powermode, 0
		jz killthepacman
		jnz killghost

		killthepacman:
			dec lives						;minus 1 life for dying obv
			mov champ_x, 23					;reset to starting position
			mov champ_y, 14
		jmp skip

		killghost:
			mov cl, ' '
			mov [esi-1], cl
			mov al, champ_xnew
			mov bl, champ_ynew
			mov champ_x, al
			mov champ_y, bl
		jmp skip
	isBonus:
		mov cl, ' '
		mov [esi-1], cl
		mov al, champ_xnew
		mov bl, champ_ynew
		mov champ_x, al
		mov champ_y, bl
		mov dx, bonus
		add score, dx
		jmp skip

	skip: ret
CheckMove ENDP

PauseScreen PROC

	colorWhite
	cmp pauseme, 1
	je PauseTitle
	jmp StartMenu

	PauseTitle:
		GoCoords 34, 3
		mov edx, OFFSET pausescreen_msg
		call WriteString
		jmp StartMenu

StartMenu:
	GoCoords 4, 7
	mov edx, OFFSET objective1
	call WriteString
	GoCoords 4, 8
	mov edx, OFFSET objective2
	call WriteString
	GoCoords 4, 10
	mov edx, OFFSET objective3
	call WriteString
	GoCoords 4, 12
	mov edx, OFFSET objective4
	call WriteString
	GoCoords 4, 14
	mov edx, OFFSET objective5
	call WriteString
	GoCoords 4, 16
	mov edx, OFFSET objective6
	call WriteString
	GoCoords 4, 18
	mov edx, OFFSET objective7
	call WriteString
	GoCoords 4, 19
	mov edx, OFFSET objective8
	call WriteString
	GoCoords 4, 21
	mov edx, OFFSET objective9
	call WriteString
	GoCoords 4, 22
	mov edx, OFFSET objective10
	call WriteString
	ret
PauseScreen ENDP

HelpScreen PROC
	colorWhite
	GoCoords 38, 3
	mov edx, OFFSET controlsTitle
	call WriteString

	GoCoords 36, 4
	mov edx, OFFSET lines
	call WriteString

	GoCoords 5, 7
	mov edx, OFFSET wButton
	call WriteString
	GoCoords 5, 9
	mov edx, OFFSET aButton
	call WriteString
	GoCoords 5, 11
	mov edx, OFFSET sButton
	call WriteString
	GoCoords 5, 13
	mov edx, OFFSET dButton
	call WriteString
	GoCoords 5, 19
	mov edx, OFFSET pButton
	call WriteString
	GoCoords 5, 21
	mov edx, OFFSET hButton
	call WriteString
	GoCoords 5, 23
	mov edx, OFFSET qButton
	call WriteString
	RET
HelpScreen ENDP

QuitScreen PROC
	call Clrscr
	mov eax, 0

	colorWhite
	GoCoords 25, 6
	mov edx, OFFSET congrats
	call WriteString 
	mov edx, OFFSET playerName
	call WriteString
	mov edx, OFFSET scoremsg
	call WriteString
	mov ax, score
	call WriteDec
	GoCoords 26, 14
	mov edx, OFFSET endScreen
	call WriteString
	GoCoords 26, 15
	mov edx, OFFSET bye
	call WriteString
	GoCoords 26, 17

	RET
QuitScreen ENDP

CheckDots PROC
	cmp dots, 70
	jz spawnbonus
	cmp dots, 170
	jz spawnbonus
	
	jmp skip

	spawnbonus:
		mov cl, '%'
		cmp level, 1
		jz level1
		cmp level, 2
		jz level2
		cmp level, 3
		jz level3
		
		level1:
			mov [mapwdots11+14], cl
			mov bonus, 100
			jmp skip
		level2:
			mov [mapwdots11+14], cl
			mov bonus, 300
			jmp skip
		level3:
			mov [mapwdots11+14], cl
			mov bonus, 500
			jmp skip
	skip:
	ret
CheckDots ENDP

CheckScore PROC
	cmp score, 10000
	jge bonuslife
	jmp hasit

	bonuslife:
		cmp hasbonuslife, 1
		jz hasit
		inc lives
		mov hasbonuslife, 1
	hasit:
	ret
CheckScore ENDP


END main