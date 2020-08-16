// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using System.Collections.Generic;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Bot.Builder;
using Microsoft.Bot.Builder.Dialogs;
using Microsoft.Bot.Schema;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using EchoBotDesktop.Entities;
using System.Security.Policy;

//using Microsoft.AdaptiveCards;
namespace Microsoft.BotBuilderSamples.Bots
{
    public class DialogAndWelcomeBot<T> : DialogBot<T>
        where T : Dialog
    {
        public DialogAndWelcomeBot(ConversationState conversationState, UserState userState, T dialog, ILogger<DialogBot<T>> logger)
            : base(conversationState, userState, dialog, logger)
        {
        }
        string RemoveBotName(string input)
        {
            string[] words = input.Split(' ');
            int start = 0;
            if (words[0][0] == '@')
                start = 1;
            string ToReturn = "";
            for (int i = start; i < words.Length; i++)
            {
                ToReturn = ToReturn + words[i] + " ";
            }
            return ToReturn;
        }
        //ngrok http -host-header="localhost:3978" 3978
        protected override async Task OnMessageActivityAsync(ITurnContext<IMessageActivity> turnContext, CancellationToken cancellationToken)
        {
            
            var message = MessageFactory.Text("Which bank account would you like to open today?");
            await turnContext.SendActivityAsync(message);
            //if(turnContext.Activity.Text!="")
            // turnContext.Activity.Text = RemoveBotName(turnContext.Activity.Text);
            //await Dialog.RunAsync(turnContext, ConversationState.CreateProperty<DialogState>("DialogState"), cancellationToken);
        }
    }
}
