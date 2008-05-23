/*
 PureMVC AS3/MultiCore Pipes Utility Unit Tests
 Copyright (c) 2008 Cliff Hall<cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.multicore.utilities.pipes.plumbing
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	
 	/**
	 * Test the Junction class.
	 */
	public class JunctionTest extends TestCase 
	{
  		
   		/**
  		 * Constructor.
  		 * 
  		 * @param methodName the name of the test method an instance to run
  		 */
 	    public function JunctionTest( methodName:String ) 
 	    {
   			super( methodName );
        }
  	
 		/**
		 * Create the TestSuite.
		 */
 		public static function suite():TestSuite 
 		{
   			var ts:TestSuite = new TestSuite();
   			
   			ts.addTest( new JunctionTest( "testRegisteringAndRetrievingAnInputPipe" ) );
   			ts.addTest( new JunctionTest( "testRegisteringAndRetrievingAnOutputPipe" ) );
   			return ts;
   		}
  		
  		/**
  		 * Test registering an INPUT pipe to a junction.
  		 * <P>
  		 * Tests that the INPUT pipe is successfully registered and
  		 * that the hasPipe and hasInputPipe methods work. Then tests
  		 * that the pipe can be retrieved by name.</P>
  		 */
  		public function testRegisteringAndRetrievingAnInputPipe():void 
  		{
  			// create pipe connected to this test with a pipelistener
   			var pipe:IPipeFitting = new Pipe( );
			
			// create junction
			var junction:Junction = new Junction();

			// register the pipe with the junction, giving it a name and direction
			var registered:Boolean=junction.registerPipe( 'testInputPipe', Junction.INPUT, pipe );
			
   			// test assertions
   			assertTrue( "Expecting pipe is Pipe", pipe is Pipe );
   			assertTrue( "Expecting junction is Junction ", junction is Junction );
   			assertTrue( "Expecting success regsitering pipe", registered );

   			// assertions about junction methods once input  pipe is registered
   			assertTrue( "Expecting junction has pipe", junction.hasPipe('testInputPipe') );
   			assertTrue( "Expecting junction has pipe registered as an INPUT type", junction.hasInputPipe('testInputPipe') );
   			assertTrue( "Expecting pipe retrieved from junction", junction.retrievePipe('testInputPipe') === pipe ); // object equality

   			// now remove the pipe and be sure that it is no longer there (same assertions should be false)
   			junction.removePipe('testInputPipe');
   			assertFalse( "Expecting junction has pipe", junction.hasPipe('testInputPipe') );
   			assertFalse( "Expecting junction has pipe registered as an INPUT type", junction.hasInputPipe('testInputPipe') );
   			assertFalse( "Expecting pipe retrieved from junction", junction.retrievePipe('testInputPipe') === pipe ); // object equality
   			
   		}

  		/**
  		 * Test registering an OUTPUT pipe to a junction.
  		 * <P>
  		 * Tests that the OUTPUT pipe is successfully registered and
  		 * that the hasPipe and hasOutputPipe methods work. Then tests
  		 * that the pipe can be retrieved by name.</P>
  		 */
  		public function testRegisteringAndRetrievingAnOutputPipe():void 
  		{
  			// create pipe connected to this test with a pipelistener
   			var pipe:IPipeFitting = new Pipe( );
			
			// create junction
			var junction:Junction = new Junction();

			// register the pipe with the junction, giving it a name and direction
			var registered:Boolean=junction.registerPipe( 'testOutputPipe',Junction.OUTPUT, pipe );
			
   			// test assertions
   			assertTrue( "Expecting pipe is Pipe", pipe is Pipe );
   			assertTrue( "Expecting junction is Junction ", junction is Junction );
   			assertTrue( "Expecting success regsitering pipe", registered );
   			
   			// assertions about junction methods once output pipe is registered
   			assertTrue( "Expecting junction has pipe", junction.hasPipe('testOutputPipe') );
   			assertTrue( "Expecting junction has pipe registered as an OUTPUT type", junction.hasOutputPipe('testOutputPipe') );
   			assertTrue( "Expecting pipe retrieved from junction", junction.retrievePipe('testOutputPipe') === pipe ); // object equality
   			
   			// now remove the pipe and be sure that it is no longer there (same assertions should be false)
   			junction.removePipe('testOutputPipe');
   			assertFalse( "Expecting junction no longer has pipe", junction.hasPipe('testOutputPipe') );
   			assertFalse( "Expecting junction has pipe registered as an OUTPUT type", junction.hasOutputPipe('testOutputPipe') );
   			assertFalse( "Expecting pipe can't be retrieved from junction", junction.retrievePipe('testOutputPipe') === pipe ); 
   		}
   		
		/**
		 * Recipient of message.
		 * <P>
		 * Used by <code>callBackMedhod</code> as a place to store
		 * the recieved message.</P>
		 */     		
   		private var messageReceived:IPipeMessage;
   		
   		/**
   		 * Callback given to <code>PipeListener</code> for incoming message.
   		 * <P>
   		 * Used by <code>testReceiveMessageViaPipeListener</code> 
   		 * to get the output of pipe back into this  test to see 
   		 * that a message passes through the pipe.</P>
   		 */
   		private function callBackMethod(message:IPipeMessage):void
   		{
   			this.messageReceived = message;
   		}
   		
	}
}