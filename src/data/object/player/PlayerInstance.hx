package data.object.player;
import data.map.MapData;
class PlayerInstance
{
    /**
     * Player ID, given by server
     */
    public var p_id:Int = 0;
    /**
     * Player's object ID, from objects
     */
    public var po_id:Int = 0;
    /**
     * facing direction 1 (right) or -1 (left)
     */
    public var facing:Int = 0;
    /**
     * N/A
     */
    public var action:Int = 0;
    /**
     * action x
     */
    public var action_target_x:Int = 0;
    /**
     * action y
     */
    public var action_target_y:Int = 0;
    /**
     * object id array from container format
     */
    public var o_id:Array<Int> = [];
    /**
     * N/A
     */
    public var o_origin_valid:Int = 0;
    /**
     * x origin 
     */
    public var o_origin_x:Int = 0;
    /**
     * y origin
     */
    public var o_origin_y:Int = 0;
    /**
     * transition source id of object
     */
    public var o_transition_source_id:Int = 0;
    /**
     * heat value
     */
    public var heat:Int = 0;
    /**
     * sequence number of done moving
     */
    public var done_moving_seqNum:Int = 0;
    /**
     * forced set pos
     */
    public var forced:Bool = false;
    /**
     * tileX int
     */
    public var x:Int = 0;
    /**
     * tileY int
     */
    public var y:Int = 0;
    /**
     * age of player
     */
    public var age:Float = 0;
    /**
     * age rate of increase
     */
    public var age_r:Float = 0;
    /**
     * move speed of player
     */
    public var move_speed:Float = 0;
    /**
     * clothing set string
     */
    public var clothing_set:String = "";
    /**
     * just ate id
     */
    public var just_ate:Int = 0;
    /**
     * last ate id
     */
    public var last_ate_id:Int = 0;
    /**
     * responsible for player id
     */
    public var responsible_id:Int = 0;
    /**
     * held yum boolean
     */
    public var held_yum:Bool = false;
    /**
     * tool learned boolean
     */
    public var held_learned:Bool = false;
    /**
     * array of properties to generate PlayerType
     * @param a 
     */
    public function new(a:Array<String>)
    {
        var index:Int = 0;
        //var name = Reflect.fields(this);
        for(value in a)
        {
            //index
            switch(index++)
            {
                case 0:
                p_id = Std.parseInt(value);
                case 1:
                po_id = Std.parseInt(value);
                case 2:
                //facing override
                facing = Std.parseInt(value);
                case 3:
                //action attempt
                action = Std.parseInt(value);
                case 4:
                action_target_x = Std.parseInt(value);
                case 5:
                action_target_y = Std.parseInt(value);
                case 6:
                o_id = MapData.id(value);
                case 7:
                o_origin_valid = Std.parseInt(value);
                case 8:
                o_origin_x = Std.parseInt(value);
                case 9:
                o_origin_y = Std.parseInt(value);
                case 10:
                o_transition_source_id = Std.parseInt(value);
                case 11:
                heat = Std.parseInt(value);
                case 12:
                done_moving_seqNum = Std.parseInt(value);
                case 13:
                ///forced
                forced = value == "1" ? true : false;
                case 14:
                x = Std.parseInt(value);
                case 15:
                y = Std.parseInt(value);
                case 16:
                age = Std.parseFloat(value);
                case 17:
                age_r = Std.parseFloat(value);
                case 18:
                move_speed = Std.parseFloat(value);
                case 19:
                clothing_set = value;
                case 20:
                just_ate = Std.parseInt(value);
                case 21:
                responsible_id = Std.parseInt(value);
                case 22:
                held_yum = value == "1" ? true : false;
                case 24:
                held_learned = value == "1" ? true : false;
            }
            //trace(name[index - 1] + ": " + value);
        }
    }
    /**
     * toString for debug
     * @return String output = "field: property"
     */
    public function toString():String
    {
        var string:String = "";
        for(field in Reflect.fields(this))
        {
            string += field + ": " + Reflect.getProperty(this,field) + "\n";
        }
        return string;
    }
}