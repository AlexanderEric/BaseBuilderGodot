# BaseBuilderGodot
Godot3 Game Project Dec. 2020

Hey! It's Eric.

So this is my current game idea! A Micromanagement BaseBuilder which uses scripting as it's gameplay loop!

Game Summary / Roadmap:

  One half of the game is the base-builder:
    Your base is composed of regions which you have control over. These regions are actually small areas made of tiles which you can manipulate. 
    By coding processes into your minions, you will harvest resources, refine materials, build things, etc. Early-game, I plan on having simple
    regions. A way to collect ore, smelt the ore, shape it into weapons and armour. Forest where you have to collect wood, clear the stump, plant 
    a seed. 
    
  Other half is the combat:
    The combat is still a bit up-in-the-air. The story will be progressed within this mode though. Basic story idea is that you are a ruler,
    and rulers all have their blessed screw. The screw is used to drill a hole into the earth, and the hole acts as a gateway to hell.
    The bigger the hole, the cooler, badder, and more absurd the items and enemies become. These items allow you to add cooler things to your base.
    Magic seeds, demonic tools, etc. There's plans such that to ramp up the absurdity, once the hole is big enough, you start drilling the atmosphere
    to create a gateway to heaven, to kill angels.
  
What is coded:

  Right now, the ScriptBox is able to parse the text, it can save it to textfiles, load textfiles, and print the files in the save directory.
  
  The Minion is able to take those commandds, and run them. One at a time. The minions basic commands are held in the _commands() function, but
  minions will all be of their own class, such as "Lumberjack" who will do the basic commands and also be able to use the lumberjack abilities.
  
  Many minions can be spawned into one level, and the player selects them by clicking on them. If there's more than one, a menu pops up
  which has the minions names (by default, named 0,1,2,etc.) The players camera is then locked to the minion.
  
  
  
  The current test scene is BasicScene.
