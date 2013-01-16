package test.client
{
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.net.SecureSocket;
import flash.text.TextField;

import org.johnnyopcode.vertx.Vertxbus;

/**
	 * ...
	 * @author David
	 */
	public class Main extends Sprite 
	{
		private var textArea:TextField;
		private var textInput:TextField;
		private var addressInput:TextField;

		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			textArea = new TextField();
			textArea.width = 800;
			textArea.height = 575;
			textArea.border = 1;
			textArea.multiline = true;
			
			textInput = new TextField();
			textInput.width = 600;
			textInput.height = 25;
			textInput.y = 575;
			textInput.border = 1;
			textInput.type = "input";

			addressInput = new TextField();
			addressInput.width = 200;
			addressInput.height = 25;
			addressInput.x = 600;
			addressInput.y = 575;
			addressInput.border = 1;
			addressInput.type = "input";
			addressInput.text = "GLOBAL";
			
			stage.addChild(textArea);
			stage.addChild(textInput);
			stage.addChild(addressInput);

			//var vertx:Vertxbus = new Vertxbus("http://localhost:8080/eventbus");
			var vertx:Vertxbus = new Vertxbus("https://localhost:4443/eventbus");
			vertx.onopen = function()
			{
				textArea.appendText("Connected\n");
				vertx.registerHandler("GLOBAL", function(body, replyHandler)
				{
					textArea.appendText("Received message on global: " + body.text + "\n");
				});
				
				textInput.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent)
				{
					if (vertx.readyState() == Vertxbus.OPEN && e.keyCode == 13)
					{
						textArea.appendText("Sent to: " + addressInput.text + " Message: " + textInput.text + "\n");
						vertx.publish(addressInput.text, { text: textInput.text }, null );
					}
				});
				addressInput.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent)
				{
					if (vertx.readyState() == Vertxbus.OPEN && e.keyCode == 13)
					{
						vertx.registerHandler(addressInput.text, null);
						textArea.appendText("Registered to receive messages addressed to " + addressInput.text + "\n");
					}
				});
			}
			vertx.onmessage = function(event)
			{
				var msg:Object = JSON.parse(event.data);
				textArea.appendText("Received message! Sent to: " + msg.address + " Message: " + event.data + "\n");
			}
			vertx.onclose = function()
			{
				textArea.appendText("Disconnected\n");
			}
			vertx.onerror = function(event)
			{
				textArea.appendText(event.text + "\n");
				//textArea.appendText("Certificate status: " + (vertx.socket.socket as SecureSocket).serverCertificateStatus + "\n");
			}
		}
		
	}
}