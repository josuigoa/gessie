package gessie.impl.openfl;

import gessie.core.ITouchHitTester;
import gessie.geom.Point;
import openfl.display.DisplayObject;
import openfl.display.InteractiveObject;
import openfl.display.Stage;
import gessie.util.Macros.*;

/**
 * ...
 * @author Kevin
 */
class OpenflTouchHitTester implements ITouchHitTester<DisplayObject>
{
	var stage:Stage;

	public function new(stage:Stage) 
	{
		assertNull(stage);
		
		this.stage = stage;
	}
	
	/* INTERFACE gessie.core.ITouchHandler.ITouchHitTester<T> */
	
	public function hitTest(point:Point, possibleTarget:DisplayObject, ?ofClass:Class<Dynamic>, ?exclude:Array<DisplayObject>):DisplayObject
	{
		if (possibleTarget != null) return possibleTarget;
		
		// try to get top target:
		var mouseChildren = true;
		var startFrom = 0;
		
		var targets = stage.getObjectsUnderPoint(point);
		if (targets.length == 0) return null;

		var startIndex = targets.length - 1 - startFrom;
		if (startIndex < 0) return null;

		var i = startIndex;
		while (i >= 0)
		{
			var target = targets[i];
			
			while (target != stage)
			{
				var io = Std.instance(target, InteractiveObject);
				if (io != null && (ofClass == null || Std.is(target, ofClass)) && (exclude == null || exclude.indexOf(target) == -1))
				{
					if (io.mouseEnabled)
					{
						var lastMouseActive = target;
						var parent = target.parent;
						while (parent != null)
						{
							if (lastMouseActive == null && parent.mouseEnabled)
								lastMouseActive = parent;
							else if (!parent.mouseChildren)
								lastMouseActive = parent.mouseEnabled ? parent : null;
								
							parent = parent.parent;
						}
						return lastMouseActive != null ? lastMouseActive : null;
					}
					else
						break; // break inner while
				}
				else
					target = target.parent;
			}
			
			i--;
		}
			
		return null;
	
	}
	
}
