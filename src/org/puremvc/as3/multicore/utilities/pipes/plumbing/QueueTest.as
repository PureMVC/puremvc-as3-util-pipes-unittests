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
	import org.puremvc.as3.multicore.utilities.pipes.messages.*;
	
 	/**
	 * Test the Queue class.
	 */
	public class QueueTest extends TestCase 
	{
  		
   		/**
  		 * Constructor.
  		 * 
  		 * @param methodName the name of the test method an instance to run
  		 */
 	    public function QueueTest( methodName:String ) 
 	    {
   			super( methodName );
        }
  	
 		/**
		 * Create the TestSuite.
		 */
 		public static function suite():TestSuite 
 		{
   			var ts:TestSuite = new TestSuite();
   			
   			ts.addTest( new QueueTest( "testConnectingIOPipes" ) );
   			ts.addTest( new QueueTest( "testWritingMultipleMessagesAndFlush" ) );
   			ts.addTest( new QueueTest( "testSortByPriorityAndFIFO" ) );
   			return ts;
   		}
  		
  		
  		/**
  		 * Test connecting input and output pipes to a queue. 
  		 */
  		public function testConnectingIOPipes():void 
  		{

  			// create output pipes 1
   			var pipe1:IPipeFitting = new Pipe();
   			var pipe2:IPipeFitting = new Pipe();

  			// create queue
   			var queue:Queue= new Queue( );
   			
   			// connect input fitting
   			var connectedInput:Boolean 	= pipe1.connect( queue );
   			
   			// connect output fitting
   			var connectedOutput:Boolean = queue.connect( pipe2 );
   			
   			// test assertions
   			assertTrue( "Expecting pipe1 is Pipe", pipe1 is Pipe );
   			assertTrue( "Expecting pipe2 is Pipe", pipe2 is Pipe );
   			assertTrue( "Expecting queue is Queue", queue is Queue );
   			assertTrue( "Expecting connected input", connectedInput );
   			assertTrue( "Expecting connected output", connectedOutput );
   		}
  		
  		
  		/**
  		 * Test writing multiple messages to the Queue followed by a Flush message.
  		 */
  		public function testWritingMultipleMessagesAndFlush():void 
  		{
			// create messages to send to the queue
   			var message1:IPipeMessage = new Message( Message.NORMAL, { testProp: 1 });
   			var message2:IPipeMessage = new Message( Message.NORMAL, { testProp: 2 });
   			var message3:IPipeMessage = new Message( Message.NORMAL, { testProp: 3 });
  			
			// create queue control flush message
   			var flush:IPipeMessage = new QueueControlMessage( QueueControlMessage.FLUSH );

  			// create queue, attaching an anonymous listener to its output
   			var queue:Queue= new Queue( new PipeListener( this ,callBackMethod ) );

   			// write messages to the queue
   			var message1written:Boolean = queue.write( message1 );
   			var message2written:Boolean = queue.write( message2 );
   			var message3written:Boolean = queue.write( message3 );
   			
   			// test assertions
			assertTrue( "Expecting message1 is IPipeMessage", message1 is IPipeMessage );
			assertTrue( "Expecting message2 is IPipeMessage", message2 is IPipeMessage );
			assertTrue( "Expecting message3 is IPipeMessage", message3 is IPipeMessage );
			assertTrue( "Expecting flush is IPipeMessage", flush is IPipeMessage );
			assertTrue( "Expecting queue is Queue", queue is Queue );

   			assertTrue( "Expecting wrote message1 to queue", message1written );
   			assertTrue( "Expecting wrote message2 to queue", message2written );
   			assertTrue( "Expecting wrote message3 to queue", message3written );

   			// test that no messages were received (they've been enqueued)
   			assertTrue( "Expecting received 0 messages", messagesReceived.length == 0 );

   			// write flush control message to the queue
   			var flushWritten:Boolean = queue.write( flush );
   			
   			// test that all messages were received, then test
   			// FIFO order by inspecting the messages themselves
   			assertTrue( "Expecting received 3 messages", messagesReceived.length == 3 );
   			
   			// test message 1 assertions 
   			var recieved1:IPipeMessage = messagesReceived.shift() as IPipeMessage;
   			assertTrue( "Expecting recieved1 is IPipeMessage", recieved1 is IPipeMessage );
   			assertTrue( "Expecting recieved1 === message1", recieved1 === message1 ); // object equality

   			// test message 2 assertions
   			var recieved2:IPipeMessage = messagesReceived.shift() as IPipeMessage;
   			assertTrue( "Expecting recieved2 is IPipeMessage", recieved2 is IPipeMessage );
   			assertTrue( "Expecting recieved2 === message2", recieved2 === message2 ); // object equality

   			// test message 3 assertions
   			var recieved3:IPipeMessage = messagesReceived.shift() as IPipeMessage;
   			assertTrue( "Expecting recieved3 is IPipeMessage", recieved3 is IPipeMessage );
   			assertTrue( "Expecting recieved3 === message3", recieved3 === message3 ); // object equality

   		}
   		
  		/**
  		 * Test the Sort-by-Priority and FIFO modes. 
  		 */
  		public function testSortByPriorityAndFIFO():void 
  		{
			// create messages to send to the queue
   			var message1:IPipeMessage = new Message( Message.NORMAL,null,null,Message.PRIORITY_MED);
   			var message2:IPipeMessage = new Message( Message.NORMAL,null,null,Message.PRIORITY_LOW);
   			var message3:IPipeMessage = new Message( Message.NORMAL,null,null,Message.PRIORITY_HIGH);
  			
  			// create queue, attaching an anonymous listener to its output
   			var queue:Queue= new Queue( new PipeListener( this ,callBackMethod ) );
   			
   			// begin sort-by-priority order mode
			var sortWritten:Boolean = queue.write(new QueueControlMessage( QueueControlMessage.SORT ));
			
   			// write messages to the queue
   			var message1written:Boolean = queue.write( message1 );
   			var message2written:Boolean = queue.write( message2 );
   			var message3written:Boolean = queue.write( message3 );
			
			// flush the queue
			var flushWritten:Boolean = queue.write(new QueueControlMessage( QueueControlMessage.FLUSH ));
			   			
   			// test assertions
   			assertTrue( "Expecting wrote sort message to queue", sortWritten);
   			assertTrue( "Expecting wrote message1 to queue", message1written );
   			assertTrue( "Expecting wrote message2 to queue", message2written );
   			assertTrue( "Expecting wrote message3 to queue", message3written );
   			assertTrue( "Expecting wrote flush message to queue", flushWritten);

   			// test that 3 messages were received
   			assertTrue( "Expecting received 3 messages", messagesReceived.length == 3 );

   			// get the messages
   			var recieved1:IPipeMessage = messagesReceived.shift() as IPipeMessage;
   			var recieved2:IPipeMessage = messagesReceived.shift() as IPipeMessage;
   			var recieved3:IPipeMessage = messagesReceived.shift() as IPipeMessage;

   			// test that the message order is sorted 
			assertTrue( "Expecting recieved1 is higher priority than recieved 2", recieved1.getPriority() < recieved2.getPriority()); 
			assertTrue( "Expecting recieved2 is higher priority than recieved 3", recieved2.getPriority() < recieved3.getPriority()); 
   			assertTrue( "Expecting recieved1 === message3", recieved1 === message3 ); // object equality
   			assertTrue( "Expecting recieved2 === message1", recieved2 === message1 ); // object equality
   			assertTrue( "Expecting recieved3 === message2", recieved3 === message2 ); // object equality

   			// begin FIFO order mode
			var fifoWritten:Boolean = queue.write(new QueueControlMessage( QueueControlMessage.FIFO ));

   			// write messages to the queue
   			var message1writtenAgain:Boolean = queue.write( message1 );
   			var message2writtenAgain:Boolean = queue.write( message2 );
   			var message3writtenAgain:Boolean = queue.write( message3 );
			
			// flush the queue
			var flushWrittenAgain:Boolean = queue.write(new QueueControlMessage( QueueControlMessage.FLUSH ));
			   			
   			// test assertions
   			assertTrue( "Expecting wrote fifo message to queue", fifoWritten);
   			assertTrue( "Expecting wrote message1 to queue again", message1writtenAgain );
   			assertTrue( "Expecting wrote message2 to queue again", message2writtenAgain );
   			assertTrue( "Expecting wrote message3 to queue again", message3writtenAgain );
   			assertTrue( "Expecting wrote flush message to queue again", flushWrittenAgain);

   			// test that 3 messages were received 
   			assertTrue( "Expecting received 3 messages", messagesReceived.length == 3 );

   			// get the messages
   			var recieved1Again:IPipeMessage = messagesReceived.shift() as IPipeMessage;
   			var recieved2Again:IPipeMessage = messagesReceived.shift() as IPipeMessage;
   			var recieved3Again:IPipeMessage = messagesReceived.shift() as IPipeMessage;

   			// test message order is FIFO
   			assertTrue( "Expecting recieved1Again === message1", recieved1Again === message1 ); // object equality
   			assertTrue( "Expecting recieved2Again === message2", recieved2Again === message2 ); // object equality
   			assertTrue( "Expecting recieved3Again === message3", recieved3Again === message3 ); // object equality
			assertTrue( "Expecting recieved1Again is priority med ", recieved1Again.getPriority() == Message.PRIORITY_MED); 
			assertTrue( "Expecting recieved2Again is priority low ", recieved2Again.getPriority() == Message.PRIORITY_LOW); 
			assertTrue( "Expecting recieved3Again is priority high ", recieved3Again.getPriority() == Message.PRIORITY_HIGH); 

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