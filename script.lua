function printStatus(astring)
  gui.text(175,10, astring);
end

function printPause()
  pauseStatus = memory.readbyte(74);
  if ((pauseStatus % 2) == 1) then
    gui.text(175,30, "Game Paused");
    emu.message("Paused")
  else 
    gui.text(175,30, "Game Resumed");
  end
end

function playerSelectStatus()
  playerSelect = memory.readbyte(71);
  astring = string.format("Player Select: %x", playerSelect);
  gui.text(175,30, astring);
end

function printSuperStatus()
  superStatus = memory.readbyte(136);
  if (superStatus == 15) then
    astring = "Super: Active"
  else
    astring = "Super:       "
  end
  gui.text(175,40, astring);
end

function printPlayerLives()
  playerSelect = memory.readbyte(103);
  astring = string.format("Player Lives: %x", playerSelect);
  gui.text(175,50, astring);
end

function printPlayerPos()
    xPos = memory.readbyte(26);
    yPos = memory.readbyte(28);
    gui.text(175,60, "Play Pos: (" .. xPos .. "," .. yPos .. ")");
end

function printPGhostPos()
    xPos = memory.readbyte(34);
    yPos = memory.readbyte(36);
    gui.text(175,70, "PGho Pos: (" .. xPos .. "," .. yPos .. ")");
end

function printRGhostPos()
    xPos = memory.readbyte(30);
    yPos = memory.readbyte(32);
    gui.text(175,80, "RGho Pos: (" .. xPos .. "," .. yPos .. ")");
end


function printDumpRam(startAdd, endAdd)
    printMem = startAdd;
    aline = 10;
    xPrint = 0;
    while (printMem < endAdd) do
        memtoPrint = memory.readbyte(printMem)
        gui.text(xPrint,aline,string.format("%x: %x", printMem, memtoPrint));
        aline = aline + 10;
        printMem = printMem + 1;
        if (aline >= 230) then
            aline = 10
            xPrint = xPrint + 40
	end
    end
end

-- 0 = Main Menu
-- 1 = Board Active
-- 2 = Demo Loading
-- 3 = Game Over
function gameStatus()
  gameStatusCode = memory.readbyte(574);
  if (gameStatusCode == 17) then
    astring = "Board Active"
    returnCode = 1
  elseif (gameStatusCode == 45) then
    astring = "Main Menu"
    returnCode = 0
  elseif (gameStatusCode == 32) then
    astring = "Demo Loading"
    returnCode = 2
  elseif (gameStatusCode == 26) then
    astring = "Game Over"
    returnCode = 3
  else
    astring = string.format("Status: %d", gameStatusCode)
    returnCode = gameStatusCode
  end
  gui.text(175,20, astring);
  return returnCode
end


--require("python")
printStatus("Initializing");
gameStatus()
startupLoop = 0;
while (startupLoop <= 40 or playerSelect == 1) do
  a = {}
  a['select'] = true
  joypad.set(1,a)
  emu.frameadvance();
  a['select'] = false
  joypad.set(1,a)
  emu.frameadvance();
  startupLoop = startupLoop + 1
  playerSelect = memory.readbyte(71);
  print(playerSelect);
  gameStatus()
end


while (true) do
  status = gameStatus()
  printDumpRam(74,75)
  if (status == 0) then
    playerSelectStatus()
  elseif (status == 1) then
    printSuperStatus()
    printPause()
    printPlayerLives()
    printPlayerPos()
    printPGhostPos()
    printRGhostPos()
  end
  emu.frameadvance();
end

a = {}
--a['start'] = true
--joypad.set(1,a)
emu.frameadvance();
--a['start'] = false
--joypad.set(1,a)
emu.frameadvance();

oldxPos = 0
a['right'] = true
a['left'] = false
a['down'] = false
inGame = false
if inGame then
    inGame = false
end
while (false) do
    --gui.text(175,10, "In Loop");
    --gui.text(175,190, "Select Pressed: " .. keyset);
    --gui.text(175,190, "Select Pressed: " .. keyPress.select);
    --if ((a['right']) and (xPos ~= oldxPos)) then
    --    a['right'] = true
    --elseif ((a['right']) and (xPos == oldxPos)) then
    --    a['right'] = false
    --    a['down'] = true
    --end
    --joypad.set(1,a)
    emu.frameadvance();
    --oldxPos = xPos
    --joypad.read(playern);
end
printStatus("Done!")
