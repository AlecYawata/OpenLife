package states.game;

import sys.io.File;
import openfl.geom.Rectangle;
import data.TgaData;
import openfl.utils.ByteArray;
import haxe.io.Input;
import openfl.display.BitmapData;
import openfl.display.Tileset;
import openfl.display.Tilemap;

class TileDisplay extends Tilemap
{
    var reader:TgaData;
    var rect:Rectangle = new Rectangle();
    var rowHeight:Float = 0;
    public var bytesArray:Array<ByteArray> = [];
    public var index:Int = 0;
    public function new(tilesetWidth:Int,tilesetHeight:Int)
    {
        super(0,0,new Tileset(new BitmapData(tilesetWidth,tilesetHeight)));
        reader = new TgaData();
    }
    public function cache(path:String)
    {
        reader.read(File.read(path,true).readAll(),function()
        {
            setRect();
            cacheRect(bytesArray.push(reader.bytes));
        });
    }
    public function cacheRect(len:Int)
    {
        
    }
    public function clearCacheRect()
    {
        bytesArray = [];
        index = tileset.numRects;
    }
    private function setRect()
    {
        if(rect.x + rect.width >= tileset.bitmapData.width)
        {
            //new row
            rect.y += rowHeight;
            rect.width = 0;
            rect.x = 0;
            rowHeight = 0;
        }
        //shift across the rows
        rect.x += rect.width;
        rect.width = reader.rect.width;
        rect.height = reader.rect.height;
        //max row height
        if (rowHeight < rect.height) rowHeight = rect.height;
        //add to tileset
        tileset.addRect(rect);
    }
}