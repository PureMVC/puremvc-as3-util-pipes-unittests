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
	 * Test the TeeSplit class.
	 */
	public class TeeSplitTest extends TestCase 
	{
  		
   		/**
  		 * Constructor.
  		 * 
  		 * @param methodName the name of the test method an instance to run
  		 */
 	    public function TeeSplitTest( methodName:String ) 
 	    {
   			super( methodName );
        }
  	
 		/**
		 * Create the TestSuite.
		 */
 		public static function suite():TestSuite 
 		{
   			var ts:TestSuite = new TestSuite();
   			
   			ts.addTest( new TeeSplitTest( "testConnectingIOPipes" ) );
   			ts.addTest( new TeeSplitTest( "testReceiveMessagesFromTwoTeeSplitOutputs" ) );
   			return ts;
   		}
  		
  		
  		/**
  		 * Test connecting an input and several output pipes to a splitting tee. 
  		 */
  		public function testConnectingIOPipes():void 
  		{
  			// create input pipe
   			var input1:IPipeFitting = new Pipe();

  			// create output pipes 1, 2, 3 and 4
   			var pipe1:IPipeFitting = new Pipe();
   			var pipe2:IPipeFitting = new Pipe();
   			var pipe3:IPipeFitting = new Pipe();
   			var pipe4:IPipeFitting = new Pipe();

  			// create splitting tee (args are first two output fittings of tee)
   			var teeSplit:TeeSplit = new TeeSplit( pipe1, pipe2 );
   			
   			// connect 2 extra outputs for a total of 4
   			var connectedExtra1:Boolean = teeSplit.connect( pipe3 );
   			var connectedExtra2:Boolean = teeSplit.connect( pipe4 );

			// connect the single input
			var inputConnected:Boolean = input1.connect(teeSplit);
			
   			// test assertions
   			assertTrue( "Expecting pipe1 is Pipe", pipe1 is Pipe );
   			assertTrue( "Expecting pipe2 is Pipe", pipe2 is Pipe );
   			assertTrue( "Expecting pipe3 is Pipe", pipe3 is Pipe );
   			assertTrue( "Expecting pipe4 is Pipe", pipe4 is Pipe );
   			assertTrue( "Expecting teeSplit is TeeSplit", teeSplit is TeeSplit );
   			assertTrue( "Expecting connected extra output 1", connectedExtra1 );
   			assertTrue( "Expecting connected extra output 2", connectedExtra2 );
   		}
  		
  		
  		/**
  		 * Test receiving messages from two pipes using a TeeMerge.
  		 */
  		public function testReceiveMessagesFromTwoTeeSplitOutputs():void 
  		{
			// create a message to send on pipe 1
   			var message:IPipeMessage = new Message( Message.NORMAL, { testProp: 1 });
  			
  			// create output pipes 1 and 2
   			var pipe1:IPipeFitting = new Pipe();
   			var pipe2:IPipeFitting = new Pipe();

			// create and connect anonymous listeners
   			var connected1:Boolean = pipe1.connect( new PipeListener( this,callBackMethod ) );
   			var connected2:Boolean = pipe2.connect( new PipeListener( this,callBackMethod ) );
   		
  			// create splitting tee (args are first two output fittings of tee)
   			var teeSplit:TeeSplit = new TeeSplit( pipe1, pipe2 );

   			// write messages to their respective pipes
   			var written:Boolean = teeSplit.write( message );
   			
   			// test assertions
			assertTrue( "Expecting message is IPipeMessage", message is IPipeMessage );
			assertTrue( "Expecting pipe1 is Pipe", pipe1 is Pipe );
			assertTrue( "Expecting pipe2 is Pipe", pipe2 is Pipe );
			assertTrue( "Expecting teeSplit is TeeSplit", teeSplit is TeeSplit );
   			assertTrue( "Expecting connected anonymous listener to pipe 1", connected1 );
   			assertTrue( "Expecting connected anonymous listener to pipe 2", connected2 );
   			assertTrue( "Expecting wrote single message to tee", written );
   			
   			// test that both messages were received, then test
   			// FIFO order by inspecting the messages themselves
   			assertTrue( "Expecting received 2 messages", messagesReceived.length == 2 );
   			
   			// test message 1 assertions 
   			var message1:IPipeMessage = messagesReceived.shift() as IPipeMessage;
   			assertTrue( "Expecting message1 is IPipeMessage", message1 is IPipeMessage );
   			assertTrue( "Expecting message1 === pipe1Message", message1 === message ); // object equality

   			// test message 2 assertions
   			var message2:IPipeMessage = messagesReceived.shift() as IPipeMessage;
   			assertTrue( "Expecting message1 is IPipeMessage", message2 is IPipeMessage );
   			assertTrue( "Expecting message1 === pipe1Message", message2 === message ); // object equality

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