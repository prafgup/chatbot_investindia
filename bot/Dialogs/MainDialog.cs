// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Bot.Builder;
using Microsoft.Bot.Builder.Dialogs;
using Microsoft.Bot.Schema;
using Microsoft.Extensions.Logging;

namespace Microsoft.BotBuilderSamples.Dialogs
{
    public class MainDialog : ComponentDialog
    {
        BookingDetails MostRecentBooking = new BookingDetails();
        protected readonly ILogger Logger;

        // Dependency injection uses this constructor to instantiate MainDialog
        public MainDialog(BookingDialog bookingDialog, ILogger<MainDialog> logger)
            : base(nameof(MainDialog))
        
        {
            Logger = logger;

            AddDialog(new TextPrompt(nameof(TextPrompt)));
            AddDialog(bookingDialog);
            AddDialog(new WaterfallDialog(nameof(WaterfallDialog), new WaterfallStep[]
            {
                IntroStepAsync,
                ActStepAsync1,
                ActStepAsync2,
                ActStepAsync3,
                ActStepAsync4,
                FinalStepAsync,
            }));

            InitialDialogId = nameof(WaterfallDialog);
            MostRecentBooking.Destination = "Not Assigned";
        }

        private async Task<DialogTurnResult> IntroStepAsync(WaterfallStepContext stepContext, CancellationToken cancellationToken)
        {
            var message = MessageFactory.Text("Which bank account would you like to open today?");
            await stepContext.Context.SendActivityAsync(message);
            message = MessageFactory.Text("That’s a great decision to have a bank account in India.");
            message.SuggestedActions = new SuggestedActions()
            {
                Actions = new List<CardAction>()
                {
                    new CardAction() { Title = "NRE Account", Type = ActionTypes.ImBack, Value = "NRE Account" },
                    new CardAction() { Title = "NRO Account", Type = ActionTypes.ImBack, Value = "NRO Account" },
                    new CardAction() { Title = "Foreign Currency Non Resident (FCNR) Account", Type = ActionTypes.ImBack, Value = "Foreign Currency Non Resident (FCNR) Account" },
                    new CardAction() { Title = "Resident Foreign Currency (RFC) Savings Account", Type = ActionTypes.ImBack, Value = "Resident Foreign Currency (RFC) Savings Account"},
                    new CardAction() { Title = "Suggest Me", Type = ActionTypes.ImBack, Value = "Suggest Me"},
                },
            };
            await stepContext.Context.SendActivityAsync(message);
            return new DialogTurnResult(DialogTurnStatus.Waiting);
        }
        private async Task<DialogTurnResult> ActStepAsync1(WaterfallStepContext stepContext, CancellationToken cancellationToken)
        {
            string Result = (string)stepContext.Result;
            if(Result.Contains("Suggest Me"))
            {
                var message = MessageFactory.Text("Sure. Let me guide you");
                await stepContext.Context.SendActivityAsync(message);
                message = MessageFactory.Text("In which currency do you want your account to be:");
                message.SuggestedActions = new SuggestedActions()
                {
                    Actions = new List<CardAction>()
                    {
                        new CardAction() { Title = "Rupee", Type = ActionTypes.ImBack, Value = "Rupee" },
                        new CardAction() { Title = "Foreign currency (USD, GBP, etc)", Type = ActionTypes.ImBack, Value = "Foreign currency (USD, GBP, etc)" },
                    },
                };
                await stepContext.Context.SendActivityAsync(message);
            }
            return new DialogTurnResult(DialogTurnStatus.Waiting);
        }
        private async Task<DialogTurnResult> ActStepAsync2(WaterfallStepContext stepContext, CancellationToken cancellationToken)
        {
            string Result = (string)stepContext.Result;
            if (Result.Contains("Rupee"))
            {
                var message = MessageFactory.Text("Do you want to transfer / invest portion of your foreign earnings to India?");
                message.SuggestedActions = new SuggestedActions()
                {
                    Actions = new List<CardAction>()
                    {
                        new CardAction() { Title = "Yes", Type = ActionTypes.ImBack, Value = "Yes r" },
                        new CardAction() { Title = "No", Type = ActionTypes.ImBack, Value = "No r" },
                    },
                };
                await stepContext.Context.SendActivityAsync(message);
            }
            else if(Result.Contains("Foreign currency (USD, GBP, etc)"))
            {
                var message = MessageFactory.Text("Are you permanently moving to India?");
                message.SuggestedActions = new SuggestedActions()
                {
                    Actions = new List<CardAction>()
                    {
                        new CardAction() { Title = "Yes", Type = ActionTypes.ImBack, Value = "Yes f" },
                        new CardAction() { Title = "No", Type = ActionTypes.ImBack, Value = "No f" },
                    },
                };
               
                await stepContext.Context.SendActivityAsync(message);
            }
            
            return new DialogTurnResult(DialogTurnStatus.Waiting);
        }
        private async Task<DialogTurnResult> ActStepAsync3(WaterfallStepContext stepContext, CancellationToken cancellationToken)
        {
            string Result = (string)stepContext.Result;
            if (Result[Result.Length-1]=='r')
            {
                if(Result.Contains("Yes"))
                {
                    var message = MessageFactory.Text("Do you have any income in India - rent, dividends, interest, etc?");
                    message.SuggestedActions = new SuggestedActions()
                    {
                        Actions = new List<CardAction>()
                        {
                            new CardAction() { Title = "Yes", Type = ActionTypes.ImBack, Value = "Yes tyr" },
                            new CardAction() { Title = "No", Type = ActionTypes.ImBack, Value = "No tyr" },
                        },
                    };
                    await stepContext.Context.SendActivityAsync(message);
                }
                else
                {
                    var message = MessageFactory.Text("Do you have any income in India - rent, dividends, interest, etc?");
                    message.SuggestedActions = new SuggestedActions()
                    {
                        Actions = new List<CardAction>()
                        {
                            new CardAction() { Title = "Yes", Type = ActionTypes.ImBack, Value = "Yes tnr" },
                            new CardAction() { Title = "No", Type = ActionTypes.ImBack, Value = "No tnr" },
                        },
                    };
                    await stepContext.Context.SendActivityAsync(message);
                }   
            }
            else
            {
                if(Result.Contains("Yes"))
                {
                    var message = MessageFactory.Text("You should open Resident Foreign Currency Account");
                    await stepContext.Context.SendActivityAsync(message);
                }
                else
                {
                    var message = MessageFactory.Text("You should open Foreign Currency Non Resident (FCNR) account");
                    await stepContext.Context.SendActivityAsync(message);
                }
            }
            return new DialogTurnResult(DialogTurnStatus.Waiting);
        }
        private async Task<DialogTurnResult> ActStepAsync4(WaterfallStepContext stepContext, CancellationToken cancellationToken)
        {
            string Result = (string)stepContext.Result;
            if (Result.Contains("Yes tyr"))
            {
                var message = MessageFactory.Text("You should open Non Resident External (NRE) as well as Non Resident Ordinary (NRO) accounts");
                await stepContext.Context.SendActivityAsync(message);
            }
            else if (Result.Contains("No tyr"))
            {
                var message = MessageFactory.Text("Since you do not have any Indian income and instead want to transfer your foreign earnings to India, you should open Non Resident External (NRE) account");
                await stepContext.Context.SendActivityAsync(message);
            }
            else if(Result.Contains("Yes tnr"))
            {
                var message = MessageFactory.Text("Since you have Indian income but do not want to transfer any foreign earnings to India, you can open Non Resident Ordinary (NRO) Account");
                await stepContext.Context.SendActivityAsync(message);
            }
            else if(Result.Contains("No tnr"))
            {
                var message = MessageFactory.Text("Do you have resident savings account in India?");
                message.SuggestedActions = new SuggestedActions()
                {
                    Actions = new List<CardAction>()
                    {
                        new CardAction() { Title = "Yes", Type = ActionTypes.ImBack, Value = "Yes resident" },
                        new CardAction() { Title = "No", Type = ActionTypes.ImBack, Value = "No resident" },
                    },
                };
                await stepContext.Context.SendActivityAsync(message);
            }
            return new DialogTurnResult(DialogTurnStatus.Waiting);
        }
        private async Task<DialogTurnResult> FinalStepAsync(WaterfallStepContext stepContext, CancellationToken cancellationToken)
        {
            string Result = (string)stepContext.Result;
            if(Result.Contains("Yes resident"))
            {
                var message = MessageFactory.Text("You should convert your existing savings account into Non Resident Ordinary (NRO) account");
                await stepContext.Context.SendActivityAsync(message);
            }
            else if(Result.Contains("No resident"))
            {
                var message = MessageFactory.Text("You can open Non Resident Ordinary (NRO) Account at this stage. Once you transfer your foreign earnings to India, you can open Non Resident External (NRE) account");
                await stepContext.Context.SendActivityAsync(message);
            }


            /*if (stepContext.Result is BookingDetails result)
            {
                var timeProperty = new TimexProperty(result.TravelDate);
                var travelDateMsg = timeProperty.ToNaturalLanguage(DateTime.Now);
                var messageText = $"I have you booked to {result.Destination} from {result.Origin} on {travelDateMsg}";
                var message = MessageFactory.Text(messageText, messageText, InputHints.IgnoringInput);
                await stepContext.Context.SendActivityAsync(message, cancellationToken);
            }
            else
            {
                string Result = (string)stepContext.Result;
                if (Result == "")
                {
                    Dictionary<string, object> kaizalaActivity = DialogUtilities.ConvertFromJsonObject<Dictionary<string, object>>(stepContext.Context.Activity.ChannelData);
                    if (kaizalaActivity.ContainsKey("eventType") && "ActionResponse".Equals(kaizalaActivity["eventType"].ToString(), StringComparison.InvariantCultureIgnoreCase))
                    {
                        if (kaizalaActivity.ContainsKey("eventData"))
                        {
                            CustomActionResponseData biometricData = DialogUtilities.ConvertFromJsonObject<CustomActionResponseData>(kaizalaActivity["eventData"]);
                            if (biometricData.IsBiometricApproved())
                            {
                                await stepContext.Context.SendActivityAsync("Your booking is cancelled");
                            }
                            else
                            {
                                await stepContext.Context.SendActivityAsync("Authentication Failed");
                            }
                        }
                    }
                }
                else if(Result!=null)
                {
                    var reply = MessageFactory.Attachment(new List<Attachment>() { GetInternetAttachment() });
                    reply.Text = "A preview of the details of your booking";
                    await stepContext.Context.SendActivityAsync(reply);
                }
            }*/
            var promptMessage = "Select an option in above card to continue";
            return await stepContext.ReplaceDialogAsync(InitialDialogId, promptMessage, cancellationToken);
        }
    }
}
