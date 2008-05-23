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
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;
	
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
   			
   			ts.addTest( new JunctionTest( "testRegisterRetrieveAndRemoveInputPipe" ) );
   			ts.addTest( new JunctionTest( "testRegisterRetrieveAndRemoveOutputPipe" ) );
   			ts.addTest( new JunctionTest( "testAddingPipeListenerToAnInputPipe" ) );
   			ts.addTest( new JunctionTest( "testSendMessageOnAnOutputPipe" ) );
   			return ts;
   		}
  		
  		/**
  		 * Test registering an INPUT pipe to a junction.
  		 * <P>
  		 * Tests that the INPUT pipe is successfully registered and
  		 * that the hasPipe and hasInputPipe methods work. Then tests
  		 * that the pipe can be retrieved by name.</P>
  		 * <P>
  		 * Finally, it removes the registered INPUT pipe and tests
  		 * that all the previous assertions about it's registration
  		 * and accessability via the Junction are no longer true.</P>
  		 */
  		public function testRegisterRetrieveAndRemoveInputPipe():void 
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
   		 * <P>
  		 * Finally, it removes the registered OUTPUT pipe and tests
  		 * that all the previous assertions about it's registration
  		 * and accessability via the Junction are no longer true.</P>
 		 */
  		public function testRegisterRetrieveAndRemoveOutputPipe():void 
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
  		 * Test adding a PipeListener to an Input Pipe.
  		 * <P>
  		 * Registers an INPUT Pipe with a Junction, then tests
  		 * the Junction's addPipeListener method, connecting
  		 * the output of the pipe back into to the test. If this
  		 * is successful, it sends a message down the pipe and 
  		 * checks to see that it was received.</P>
 		 */
  		public function testAddingPipeListenerToAnInputPipe():void 
  		{
  			// create pipe 
   			var pipe:IPipeFitting = new Pipe( );
			
			// create junction
			var junction:Junction = new Junction();

			// create test message
			var message:IPipeMessage = new Message(Message.NORMAL, {testVal:1});
			
			// register the pipe with the junction, giving it a name and direction
			var registered:Boolean=junction.registerPipe( 'testInputPipe', Junction.INPUT, pipe );

			// add the pipelistener using the junction method
			var listenerAdded:Boolean = junction.addPipeListener('testInputPipe', this, callBackMethod);
						
			// send the message using our reference to the pipe, 
			// it should show up in messageReceived property via the pipeListener
			var sent:Boolean = pipe.write(message); 
			
			// test assertions
   			assertTrue( "Expecting pipe is Pipe", pipe is Pipe );
   			assertTrue( "Expecting junction is Junction ", junction is Junction );
   			assertTrue( "Expecting regsitered pipe", registered );
   			assertTrue( "Expecting added pipeListener", listenerAdded );
   			assertTrue( "Expecting successful write to pipe", sent );
			assertTrue( "Expecting 1 message received", messagesReceived.length = 1); 
			assertTrue( "Expecting received message was same instance sent", messagesReceived.pop() === message); //object equality
			   			   			
   		}
   		
  		/**
  		 * Test using sendMessage on an OUTPUT pipe.
  		 * <P>
  		 * Creates a Pipe, Junction and Message. 
  		 * Adds the PipeListener to the Pipe.
  		 * Adds the Pipe to the Junction as an OUTPUT pipe.
  		 * uses the Junction's sendMessage method to send
  		 * the Message, then checks that it was received.</P>
 		 */
  		public function testSendMessageOnAnOutputPipe():void 
  		{
   			// create pipe 
   			var pipe:IPipeFitting = new Pipe( );
			
			// add a PipeListener manually 
			var listenerAdded:Boolean = pipe.connect(new PipeListener(this, callBackMethod));
						
			// create junction
			var junction:Junction = new Junction();

			// create test message
			var message:IPipeMessage = new Message(Message.NORMAL, {testVal:1});
			
			// register the pipe with the junction, giving it a name and direction
			var registered:Boolean=junction.registerPipe( 'testOutputPipe', Junction.OUTPUT, pipe );

			// send the message using the Junction's method 
			// it should show up in messageReceived property via the pipeListener
			var sent:Boolean = junction.sendMessage('testOutputPipe',message);
			
			// test assertions
   			assertTrue( "Expecting pipe is Pipe", pipe is Pipe );
   			assertTrue( "Expecting junction is Junction ", junction is Junction );
   			assertTrue( "Expecting regsitered pipe", registered );
   			assertTrue( "Expecting added pipeListener", listenerAdded );
   			assertTrue( "Expecting message sent", sent );
			assertTrue( "Expecting 1 message received", messagesReceived.length = 1); 
			assertTrue( "Expecting received message was same instance sent", messagesReceived.pop() === message); //object equality
   		}
   		
   		
		/**
		 * Array of received messages.
		 * <P>
		 * Used by <code>callBackMedhod</code> as a place to store
		 * the recieved messages.</P>
		 */     		
   		private var messagesReceived:Array = new Array();
   		
   		/**
   		 * Callback given to <code>PipeListener</code> for incoming message.
   		 * <P>
   		 * Used by <code>testReceiveMessageViaPipeListener</code> 
   		 * to get the output of pipe back into this  test to see 
   		 * that a message passes through the pipe.</P>
   		 */
   		private function callBackMethod( message:IPipeMessage ):void
   		{
   			this.messagesReceived.push( message );
   		}
   		
	}
}