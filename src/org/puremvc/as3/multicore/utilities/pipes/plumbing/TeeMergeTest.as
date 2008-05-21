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
	 * Test the TeeMerge class.
	 */
	public class TeeMergeTest extends TestCase 
	{
  		
   		/**
  		 * Constructor.
  		 * 
  		 * @param methodName the name of the test method an instance to run
  		 */
 	    public function TeeMergeTest( methodName:String ) 
 	    {
   			super( methodName );
        }
  	
 		/**
		 * Create the TestSuite.
		 */
 		public static function suite():TestSuite 
 		{
   			var ts:TestSuite = new TestSuite();
   			
   			ts.addTest( new TeeMergeTest( "testConnectingIOPipes" ) );
   			ts.addTest( new TeeMergeTest( "testReceiveMessagesFromTwoPipesViaTeeMerge" ) );
   			ts.addTest( new TeeMergeTest( "testReceiveMessagesFromFourPipesViaTeeMerge" ) );
   			return ts;
   		}
  		
  		/**
  		 * Test connecting an output and several input pipes to a merging tee. 
  		 */
  		public function testConnectingIOPipes():void 
  		{
  			// create input pipe
   			var output1:IPipeFitting = new Pipe();

  			// create input pipes 1, 2, 3 and 4
   			var pipe1:IPipeFitting = new Pipe();
   			var pipe2:IPipeFitting = new Pipe();
   			var pipe3:IPipeFitting = new Pipe();
   			var pipe4:IPipeFitting = new Pipe();

  			// create splitting tee (args are first two input fittings of tee)
   			var teeMerge:TeeMerge = new TeeMerge( pipe1, pipe2 );
   			
   			// connect 2 extra inputs for a total of 4
   			var connectedExtra1:Boolean = teeMerge.connectInput( pipe3 );
   			var connectedExtra2:Boolean = teeMerge.connectInput( pipe4 );

			// connect the single output
			var connected:Boolean = output1.connect(teeMerge);
			
   			// test assertions
   			assertTrue( "Expecting pipe1 is Pipe", pipe1 is Pipe );
   			assertTrue( "Expecting pipe2 is Pipe", pipe2 is Pipe );
   			assertTrue( "Expecting pipe3 is Pipe", pipe3 is Pipe );
   			assertTrue( "Expecting pipe4 is Pipe", pipe4 is Pipe );
   			assertTrue( "Expecting teeMerge is TeeMerge", teeMerge is TeeMerge );
   			assertTrue( "Expecting connected extra input 1", connectedExtra1 );
   			assertTrue( "Expecting connected extra input 2", connectedExtra2 );
   		}

  		/**
  		 * Test receiving messages from two pipes using a TeeMerge.
  		 */
  		public function testReceiveMessagesFromTwoPipesViaTeeMerge():void 
  		{
			// create a message to send on pipe 1
   			var pipe1Message:IPipeMessage = new Message( Message.TYPE_NORMAL, 
   													     { testProp: 1 },
   														  new XML(<testMessage testAtt='Pipe 1 Message'/>),
   													      Message.PRIORITY_LOW );
			// create a message to send on pipe 2
   			var pipe2Message:IPipeMessage = new Message( Message.TYPE_NORMAL, 
   													     { testProp: 2  },
   														  new XML(<testMessage testAtt='Pipe 2 Message'/>),
   													      Message.PRIORITY_HIGH );
  			// create pipes 1 and 2
   			var pipe1:IPipeFitting = new Pipe();
   			var pipe2:IPipeFitting = new Pipe();
   			
  			// create merging tee (args are first two input fittings of tee)
   			var teeMerge:TeeMerge = new TeeMerge( pipe1, pipe2 );

			// create listener
   			var listener:PipeListener = new PipeListener( this,callBackMethod );
   			
   			// connect the listener to the tee and write the messages
   			var connected:Boolean = teeMerge.connect(listener);
   			
   			// write messages to their respective pipes
   			var pipe1written:Boolean = pipe1.write( pipe1Message );
   			var pipe2written:Boolean = pipe2.write( pipe2Message );
   			
   			// test assertions
			assertTrue( "Expecting pipe1Message is IPipeMessage", pipe1Message is IPipeMessage );
			assertTrue( "Expecting pipe2Message is IPipeMessage", pipe2Message is IPipeMessage );
			assertTrue( "Expecting pipe1 is Pipe", pipe1 is Pipe );
			assertTrue( "Expecting pipe2 is Pipe", pipe2 is Pipe );
			assertTrue( "Expecting teeMerge is TeeMerge", teeMerge is TeeMerge );
			assertTrue( "Expecting listener is PipeListener", listener is PipeListener );
   			assertTrue( "Expecting connected listener to merging tee", connected );
   			assertTrue( "Expecting wrote message to pipe 1", pipe1written );
   			assertTrue( "Expecting wrote message to pipe 2", pipe2written );
   			
   			// test that both messages were received, then test
   			// FIFO order by inspecting the messages themselves
   			assertTrue( "Expecting received 2 messages", messagesReceived.length = 2 );
   			
   			// test message 1 assertions 
   			var message1:IPipeMessage = messagesReceived.shift() as IPipeMessage;
   			assertTrue( "Expecting message1 is IPipeMessage", message1 is IPipeMessage );
   			assertTrue( "Expecting message1 === pipe1Message", message1 === pipe1Message ); // object equality
   			assertTrue( "Expecting message1.getType() == Message.TYPE_NORMAL", message1.getType() == Message.TYPE_NORMAL );
   			assertTrue( "Expecting message1.getHeader().testProp == 1", message1.getHeader().testProp == 1);
   			assertTrue( "Expecting message1.getBody().@testAtt == 'Pipe 1 Message'",  message1.getBody().@testAtt == 'Pipe 1 Message');
   			assertTrue( "Expecting message1.getPriority() == Message.PRIORITY_LOW",  message1.getPriority() == Message.PRIORITY_LOW);

   			// test message 2 assertions
   			var message2:IPipeMessage = messagesReceived.shift() as IPipeMessage;
   			assertTrue( "Expecting message2 is IPipeMessage", message2 is IPipeMessage );
   			assertTrue( "Expecting message2 === pipe2Message", message2 === pipe2Message ); // object equality
   			assertTrue( "Expecting message2.getType() == Message.TYPE_NORMAL", message2.getType() == Message.TYPE_NORMAL );
   			assertTrue( "Expecting message2.getHeader().testProp == 2", message2.getHeader().testProp == 2);
   			assertTrue( "Expecting message2.getBody().@testAtt == 'Pipe 2 Message'",  message2.getBody().@testAtt == 'Pipe 2 Message');
   			assertTrue( "Expecting message2.getPriority() == Message.PRIORITY_HIGH",  message2.getPriority() == Message.PRIORITY_HIGH);

   		}
   		
  		/**
  		 * Test receiving messages from four pipes using a TeeMerge.
  		 */
  		public function testReceiveMessagesFromFourPipesViaTeeMerge():void 
  		{
			// create a message to send on pipe 1
   			var pipe1Message:IPipeMessage = new Message( Message.TYPE_NORMAL, { testProp: 1 } );
   			var pipe2Message:IPipeMessage = new Message( Message.TYPE_NORMAL, { testProp: 2 } );
   			var pipe3Message:IPipeMessage = new Message( Message.TYPE_NORMAL, { testProp: 3 } );
   			var pipe4Message:IPipeMessage = new Message( Message.TYPE_NORMAL, { testProp: 4 } );

  			// create pipes 1, 2, 3 and 4
   			var pipe1:IPipeFitting = new Pipe();
   			var pipe2:IPipeFitting = new Pipe();
   			var pipe3:IPipeFitting = new Pipe();
   			var pipe4:IPipeFitting = new Pipe();
   			
  			// create merging tee
   			var teeMerge:TeeMerge = new TeeMerge( pipe1, pipe2 );
   			var connectedExtraInput3:Boolean = teeMerge.connectInput(pipe3);
   			var connectedExtraInput4:Boolean = teeMerge.connectInput(pipe4);

			// create listener
   			var listener:PipeListener = new PipeListener( this,callBackMethod );
   			
   			// connect the listener to the tee and write the messages
   			var connected:Boolean = teeMerge.connect(listener);
   			
   			// write messages to their respective pipes
   			var pipe1written:Boolean = pipe1.write( pipe1Message );
   			var pipe2written:Boolean = pipe2.write( pipe2Message );
   			var pipe3written:Boolean = pipe3.write( pipe3Message );
   			var pipe4written:Boolean = pipe4.write( pipe4Message );
   			
   			// test assertions
			assertTrue( "Expecting pipe1Message is IPipeMessage", pipe1Message is IPipeMessage );
			assertTrue( "Expecting pipe2Message is IPipeMessage", pipe2Message is IPipeMessage );
			assertTrue( "Expecting pipe3Message is IPipeMessage", pipe3Message is IPipeMessage );
			assertTrue( "Expecting pipe4Message is IPipeMessage", pipe4Message is IPipeMessage );
			assertTrue( "Expecting pipe1 is Pipe", pipe1 is Pipe );
			assertTrue( "Expecting pipe2 is Pipe", pipe2 is Pipe );
			assertTrue( "Expecting pipe3 is Pipe", pipe3 is Pipe );
			assertTrue( "Expecting pipe4 is Pipe", pipe4 is Pipe );
			assertTrue( "Expecting teeMerge is TeeMerge", teeMerge is TeeMerge );
			assertTrue( "Expecting listener is PipeListener", listener is PipeListener );
   			assertTrue( "Expecting connected listener to merging tee", connected );
   			assertTrue( "Expecting connected extra input pipe3 to merging tee", connectedExtraInput3 );
   			assertTrue( "Expecting connected extra input pipe4 to merging tee", connectedExtraInput4 );
   			assertTrue( "Expecting wrote message to pipe 1", pipe1written );
   			assertTrue( "Expecting wrote message to pipe 2", pipe2written );
   			assertTrue( "Expecting wrote message to pipe 3", pipe3written );
   			assertTrue( "Expecting wrote message to pipe 4", pipe4written );
   			
   			// test that both messages were received, then test
   			// FIFO order by inspecting the messages themselves
   			assertTrue( "Expecting received 4 messages", messagesReceived.length = 4 );
   			
   			// test message 1 assertions 
   			var message1:IPipeMessage = messagesReceived.shift() as IPipeMessage;
   			assertTrue( "Expecting message1 is IPipeMessage", message1 is IPipeMessage );
   			assertTrue( "Expecting message1 === pipe1Message", message1 === pipe1Message ); // object equality
   			assertTrue( "Expecting message1.getType() == Message.TYPE_NORMAL", message1.getType() == Message.TYPE_NORMAL );
   			assertTrue( "Expecting message1.getHeader().testProp == 1", message1.getHeader().testProp == 1);

   			// test message 2 assertions
   			var message2:IPipeMessage = messagesReceived.shift() as IPipeMessage;
   			assertTrue( "Expecting message2 is IPipeMessage", message2 is IPipeMessage );
   			assertTrue( "Expecting message2 === pipe2Message", message2 === pipe2Message ); // object equality
   			assertTrue( "Expecting message2.getType() == Message.TYPE_NORMAL", message2.getType() == Message.TYPE_NORMAL );
   			assertTrue( "Expecting message2.getHeader().testProp == 2", message2.getHeader().testProp == 2);

   			// test message 3 assertions 
   			var message3:IPipeMessage = messagesReceived.shift() as IPipeMessage;
   			assertTrue( "Expecting message3 is IPipeMessage", message3 is IPipeMessage );
   			assertTrue( "Expecting message3 === pipe3Message", message3 === pipe3Message ); // object equality
   			assertTrue( "Expecting message3.getType() == Message.TYPE_NORMAL", message3.getType() == Message.TYPE_NORMAL );
   			assertTrue( "Expecting message3.getHeader().testProp == 3", message3.getHeader().testProp == 3);

   			// test message 4 assertions
   			var message4:IPipeMessage = messagesReceived.shift() as IPipeMessage;
   			assertTrue( "Expecting message4 is IPipeMessage", message2 is IPipeMessage );
   			assertTrue( "Expecting message4 === pipe4Message", message4 === pipe4Message ); // object equality
   			assertTrue( "Expecting message4.getType() == Message.TYPE_NORMAL", message4.getType() == Message.TYPE_NORMAL );
   			assertTrue( "Expecting message4.getHeader().testProp == 4", message4.getHeader().testProp == 4);

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