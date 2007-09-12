package tests.com.sophware.undoredo.control
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class SampleMatrixEvent extends CairngormEvent
	{
		public function SampleMatrixEvent(data:Object) : void
		{
			super("sample_matrix");
			this.data = data;
		}
	}
}