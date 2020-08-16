// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using System.Threading;
using System.Threading.Tasks;
using Microsoft.Bot.Builder;
using Microsoft.Bot.Builder.Dialogs;
using Microsoft.Bot.Schema;
using Microsoft.Recognizers.Text.DataTypes.TimexExpression;
using EchoBotDesktop.Entities;
using Microsoft.Bot.Connector;
using Microsoft.Bot.Connector.Authentication;
using System;
using System.Net.Http;

namespace Microsoft.BotBuilderSamples.Dialogs
{
    public class BookingDialog : CancelAndHelpDialog
    {
        private const string DestinationStepMsgText = "Where would you like to travel to?";
        private const string OriginStepMsgText = "Where are you traveling from?";

        public BookingDialog()
            : base(nameof(BookingDialog))
        {
            AddDialog(new TextPrompt(nameof(TextPrompt)));
            AddDialog(new ConfirmPrompt(nameof(ConfirmPrompt)));
            AddDialog(new DateResolverDialog());
            AddDialog(new WaterfallDialog(nameof(WaterfallDialog), new WaterfallStep[]
            {
                DestinationStepAsync,
                OriginStepAsync,
                TravelDateStepAsync,
                ConfirmStepAsync,
                ChooseSeatsStep,
                FinalStepAsync,
            }));

            // The initial child Dialog to run.
            InitialDialogId = nameof(WaterfallDialog);
        }

        private async Task<DialogTurnResult> DestinationStepAsync(WaterfallStepContext stepContext, CancellationToken cancellationToken)
        {
            var bookingDetails = (BookingDetails)stepContext.Options;

            if (bookingDetails.Destination == null)
            {
                var promptMessage = MessageFactory.Text(DestinationStepMsgText, DestinationStepMsgText, InputHints.ExpectingInput);
                return await stepContext.PromptAsync(nameof(TextPrompt), new PromptOptions { Prompt = promptMessage }, cancellationToken);
            }

            return await stepContext.NextAsync(bookingDetails.Destination, cancellationToken);
        }

        private async Task<DialogTurnResult> OriginStepAsync(WaterfallStepContext stepContext, CancellationToken cancellationToken)
        {
            var bookingDetails = (BookingDetails)stepContext.Options;

            bookingDetails.Destination = (string)stepContext.Result;

            if (bookingDetails.Origin == null)
            {
                var promptMessage = MessageFactory.Text(OriginStepMsgText, OriginStepMsgText, InputHints.ExpectingInput);
                return await stepContext.PromptAsync(nameof(TextPrompt), new PromptOptions { Prompt = promptMessage }, cancellationToken);
            }

            return await stepContext.NextAsync(bookingDetails.Origin, cancellationToken);
        }

        private async Task<DialogTurnResult> TravelDateStepAsync(WaterfallStepContext stepContext, CancellationToken cancellationToken)
        {
            var bookingDetails = (BookingDetails)stepContext.Options;

            bookingDetails.Origin = (string)stepContext.Result;
            //string date = bookingDetails.TravelDate;
            /*if(date!=null)
            {
                string[] words = date.Split(' ');
                int start = 0;
                if (words[0][0] == '@')
                    start = 1;
                date = "";
                for (int i = start; i < words.Length; i++)
                {
                    date = date + words[i] + " ";
                }
                bookingDetails.TravelDate = date;
            }*/
            
            if (bookingDetails.TravelDate == null || IsAmbiguous(bookingDetails.TravelDate))
            {
                return await stepContext.BeginDialogAsync(nameof(DateResolverDialog), bookingDetails.TravelDate, cancellationToken);
            }

            return await stepContext.NextAsync(bookingDetails.TravelDate, cancellationToken);
        }
        private IMessageActivity CreateAnnouncement(Activity incomingActivity, string input)
        {
            //var message = new Activity();
            var message = (Activity)incomingActivity.CreateReply();
            
            KaizalaActivity kaizalaActivity = new KaizalaActivity();
            kaizalaActivity.KaizalaActivityType = KaizalaActivityType.SendAction_CustomAction;
            kaizalaActivity.ActivityData = new ActionData()
            {
                ActionType = ActionType.Announcement,
                ActionBody = new AnnouncementData()
                {
                    Title = "Flight Booking",
                    Message = input
                }
            };

            message.ChannelData = kaizalaActivity;

            return message;
        }
        private IMessageActivity CreateAvailableSeatsResponseMessage(Activity incomingActivity)
        {
            var message = incomingActivity.CreateReply();
            message.Text = "Seats";
            Attachment atchmnt = new Attachment();
            atchmnt.ContentUrl = "https://www.soundczech.cz/temp/lorem-ipsum.pdf";
            //atchmnt.ContentUrl = "https://microsoft-my.sharepoint.com/:b:/p/t-bhbhaw/EQ4wxToN0slKpL_5gJxlxUMBkxKzGXgcaf7lEOrNSbHLIw?e=f416XK";
            atchmnt.ContentType = "application/pdf";
            message.Attachments.Add(atchmnt);
            return message;
        }
        private async Task<DialogTurnResult> ConfirmStepAsync(WaterfallStepContext stepContext, CancellationToken cancellationToken)
        {
            var bookingDetails = (BookingDetails)stepContext.Options;

            bookingDetails.TravelDate = (string)stepContext.Result;

            var messageText = $"Please confirm, I have you traveling to: {bookingDetails.Destination} from: {bookingDetails.Origin} on: {bookingDetails.TravelDate}. Is this correct?";
            var promptMessage = MessageFactory.Text(messageText, messageText, InputHints.ExpectingInput);
            return await stepContext.PromptAsync(nameof(TextPrompt), new PromptOptions { Prompt = promptMessage }, cancellationToken);   
        }

        private async Task<DialogTurnResult> ChooseSeatsStep(WaterfallStepContext stepContext, CancellationToken cancellationToken)
        {
            string ReceivedResponse = (string)stepContext.Result;
            if(ReceivedResponse.Contains("yes"))
            {
                
                string messageText = "Here is the chart of available seats, please select a suitable seat number.";
                var incomingActivity = stepContext.Context.Activity;
                var attachment = CreateAvailableSeatsResponseMessage(incomingActivity);
                await stepContext.Context.SendActivityAsync(attachment);
                var promptMessage = MessageFactory.Text(messageText, messageText, InputHints.ExpectingInput);
                return await stepContext.PromptAsync(nameof(TextPrompt), new PromptOptions { Prompt = promptMessage }, cancellationToken);
            }
            else
            {
                await stepContext.Context.SendActivityAsync("Cancelling ongoing booking");
                return await stepContext.EndDialogAsync(null, cancellationToken);
            }
        }

        private async Task<DialogTurnResult> FinalStepAsync(WaterfallStepContext stepContext, CancellationToken cancellationToken)
        {            
            var bookingDetails = (BookingDetails)stepContext.Options;
            var ReceivedActivity = (Activity)stepContext.Context.Activity;
            string messageText = "Your ticket is booked";
            var action_card = CreateAnnouncement(ReceivedActivity, messageText);
            await stepContext.Context.SendActivityAsync(action_card);
            //var conn = new ConnectorClient(new Uri(stepContext.Context.Activity.ServiceUrl), "489c1823-e267-4643-a141-59c2556294c0", "AVVqnz5WC1txqzL-7cO~-wPev_km.681.Z");
            //await conn.Conversations.SendToConversationAsync((Activity)action_card);
            //await stepContext.Context.SendActivityAsync(action_card);
            return await stepContext.EndDialogAsync(bookingDetails, cancellationToken);
        }

        private static bool IsAmbiguous(string timex)
        {
            var timexProperty = new TimexProperty(timex);
            return !timexProperty.Types.Contains(Microsoft.Recognizers.Text.DataTypes.TimexExpression.Constants.TimexTypes.Definite);
        }
    }
}
