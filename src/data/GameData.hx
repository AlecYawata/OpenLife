package data;
import haxe.ds.ObjectMap;
import data.object.ObjectData;
import game.Player;
#if full
import game.Ground;
import data.transition.TransitionData;
import data.map.MapData;
#end
import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;
#if openfl
import data.animation.emote.EmoteData;
import data.display.TileData;
import openfl.display.TileContainer;
import openfl.display.Tile;
import openfl.geom.Rectangle;
import haxe.ds.Vector;
import data.object.SpriteData;
#end
//data stored for the game to function (map data -> game data)
class GameData
{
    /**
     * Blocking tiles mapped, "x.y"
     */
    public var blocking:Map<String,Bool> = new Map<String,Bool>();
    public var playerMap:Map<Int,Player> = new Map<Int,Player>();
    #if full
    /**
     * Transition data
     */
    public var transitionData:TransitionData;
    /**
     * Map data (ground,floor,objects)
     */
    public var map:MapData;
    #end
    #if openfl
    /**
     * Map of sprites, id to data
     */
    public var spriteMap:Map<Int,SpriteData> = new Map<Int,SpriteData>();
    #end
    /**
     * Map of objects, id to data
     */
    public var objectMap:Map<Int,ObjectData> = new Map<Int,ObjectData>();
    /**
     * total non generated objects
     */
    public var nextObjectNumber:Int = 0;
    #if openfl
    /**
     * Tile data
     */
    public var tileData:TileData;
    /**
     * Emote static array
     */
    public var emotes:Vector<EmoteData>;
    #end
    public function new()
    {
        #if openfl
        tileData = new TileData();
        #end
        //transitionData = new TransitionData();
        #if openfl
        emoteData();
        #end
        #if full
        map = new MapData();
        objectData();
        #end
    }
    #if openfl
    /**
     * OpenFL generate emote data
     */
    private function emoteData()
    {
        if (!Main.settings.data.exists("emotionObjects") || Main.settings.data.exists("emotionWords"))
        {
            trace("no emote data in settings");
            return;
        }
        var arrayObj:Array<String> = Main.settings.data.get("emotionObjects").split("\n");
        var arrayWord:Array<String> = Main.settings.data.get("emotionWords").split("\n");
        emotes = new Vector<EmoteData>(arrayObj.length);
        for (i in 0...arrayObj.length) emotes[i] = new EmoteData(arrayWord[i],arrayObj[i]);
    }
    #end
    /**
     * Generate object data
     */
    private function objectData()
    {
        //nextobject
        nextObjectNumber = Std.parseInt(File.getContent(Static.dir + "objects/nextObjectNumber.txt"));
        //go through objects
        var list:Array<Int> = [];
        UnitTest.inital();
        for (path in FileSystem.readDirectory(Static.dir + "objects"))
        {
            list.push(Std.parseInt(Path.withoutExtension(path)));
        }
        trace("read dir " + UnitTest.stamp());
        list.sort(function(a:Int,b:Int)
        {
            if (a > b) return 1;
            return -1;
        });
        trace("sort " + UnitTest.stamp());
        var nextObjectNumberInt = nextObjectNumber;
        var data:ObjectData;
        var dummyObject:ObjectData;
        for (i in list) 
        {
            data = new ObjectData(i);
            //set num uses everything else should be set for cloning
            if (data.numUses > 1)
            {
                for (j in 0...data.numUses - 1) 
                {
                    dummyObject = data.clone();
                    dummyObject.id = ++nextObjectNumberInt;
                    dummyObject.numUses = 0;
                    dummyObject.dummy = true;
                    dummyObject.dummyParent = data.id;
                    dummyObject.dummyIndex = j + 1;
                    objectMap.set(dummyObject.id,dummyObject);
                }
            }
            objectMap.set(data.id,data);
        }
    }
}