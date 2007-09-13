package tests.com.sophware.undoredo.control
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class SampleMatrixEvent extends CairngormEvent
	{
		public static const POINT:String = "sample_matrix_event";
		
		public function SampleMatrixEvent(data:Object) : void
		{
			super(POINT);
			this.data = data;
		}
	}
}