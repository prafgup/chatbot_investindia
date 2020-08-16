// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Bot.Builder;
using Microsoft.Bot.Builder.Dialogs;
using Microsoft.Bot.Schema;
using Microsoft.Extensions.Logging;
using Microsoft.Recognizers.Text.DataTypes.TimexExpression;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Bot.Builder;
using Microsoft.Bot.Schema;
using Microsoft.Bot.Connector;
using System;
using System;
using System.Text;
using System.Net;
using System.IO;
using System.Collections.Generic;
using Newtonsoft.Json;
using System.Text.Json;
using System.Linq;
using System.Runtime.CompilerServices;

namespace Microsoft.BotBuilderSamples.Dialogs
{
    public class MainDialog : ComponentDialog
    {
        private readonly FlightBookingRecognizer _luisRecognizer;
        protected readonly ILogger Logger;

        // Dependency injection uses this constructor to instantiate MainDialog
        public MainDialog(FlightBookingRecognizer luisRecognizer, BookingDialog bookingDialog, ILogger<MainDialog> logger)
            : base(nameof(MainDialog))
        {
            _luisRecognizer = luisRecognizer;
            Logger = logger;

            AddDialog(new TextPrompt(nameof(TextPrompt)));
            AddDialog(bookingDialog);
            AddDialog(new WaterfallDialog(nameof(WaterfallDialog), new WaterfallStep[]
            {
                IntroStepAsync,
                //ActStepAsync,
                //FinalStepAsync,
            }));

            // The initial child Dialog to run.
            InitialDialogId = nameof(WaterfallDialog);
        }

        /*private async Task<DialogTurnResult> IntroStepAsync(WaterfallStepContext stepContext, CancellationToken cancellationToken)
        {
            
                var message = MessageFactory.Text("You can ask me questions on taking loans, opening bank accounts in India etc.");
                await stepContext.Context.SendActivityAsync(message);
            
            return new DialogTurnResult(DialogTurnStatus.Waiting);
        }*/
        public static string GetResponseFromWeb(string query)
        {
            const string accessKey = "d9bc12545d374be5821802d409ad2817";
            const string uriBase = "https://api.cognitive.microsoft.com/bing/v7.0/search";
            var uriQuery = uriBase + "?q=" + Uri.EscapeDataString(query);
            WebRequest request = HttpWebRequest.Create(uriQuery);
            request.Headers["Ocp-Apim-Subscription-Key"] = accessKey;
            HttpWebResponse response = (HttpWebResponse)request.GetResponseAsync().Result;
            string json = new StreamReader(response.GetResponseStream()).ReadToEnd();
            string responseString = "You may find following responses from web useful:\n\n\n";
            var jsonDoc = JsonDocument.Parse(json);
            var root = jsonDoc.RootElement;
            var myString = root.GetProperty("webPages").GetRawText();
            var webPagesDoc = JsonDocument.Parse(myString);
            var webPagesDocRoot = webPagesDoc.RootElement;
            var value = webPagesDocRoot.GetProperty("value").GetRawText();
            var valuesDoc = JsonDocument.Parse(value);
            var valuesDocRoot = valuesDoc.RootElement;
            for (int i = 0; i < Math.Min(3, valuesDocRoot.GetArrayLength()); i++)
            {
                var v = valuesDocRoot[i].GetRawText();
                var vDoc = JsonDocument.Parse(v);
                var vRoot = vDoc.RootElement;
                var snippet = vRoot.GetProperty("snippet").GetString();
                var url = vRoot.GetProperty("url").GetString();
                responseString = responseString + (snippet) + "\n\n\nLink: " + (url) + "\n\n\n";
            }
            responseString = responseString + "Or you can visit the Requests section in the app.";
            return responseString;
        }

        private async Task<DialogTurnResult> IntroStepAsync(WaterfallStepContext stepContext, CancellationToken cancellationToken)
        {
            string Result = (string)stepContext.Context.Activity.Text;
            if (!_luisRecognizer.IsConfigured)
            {
                // LUIS is not configured, we just run the BookingDialog path with an empty BookingDetailsInstance.
                return await stepContext.BeginDialogAsync(nameof(BookingDialog), new BookingDetails(), cancellationToken);
            }
            
            var luisResult = await _luisRecognizer.RecognizeAsync<FlightBooking>(stepContext.Context, cancellationToken);
            var top_score = luisResult.TopIntent().score;
            if(top_score>0.67)
            {
                switch (luisResult.TopIntent().intent)//add take loan general
                {
                    case FlightBooking.Intent.post_office:
                        var message = MessageFactory.Text("Non resident Indians (NRIs) are not allowed to invest in post office savings schemes. This means they cannot invest in instruments like the National Savings Certificates, Public Provident Fund, Monthly Income Schemes and other time deposits offered by the post office\n. If an NRI needs to invest in the post office savings scheme he or she can still do so. He or she would have to do it through his parents or other friends who are resident Indians and in their name. However, in that case remember that your parents income is taxable, since post office schemes attract tax, apart from the PPPF.");
                        await stepContext.Context.SendActivityAsync(message);
                        break;
                    case FlightBooking.Intent.invest_gold:
                        message = MessageFactory.Text("NRIs can import gold bars, coins and ornaments up to 1 kg during their visit to India. The only pre-condition being that they should have stayed abroad for a period of six months or more.\n\nThe advent of Gold ETFs has made the purchase of gold as simple and convenient as buying stocks. “NRIs can invest in Gold ETFs in India.If they are buying through the exchange, then NRIs must have a PINS account.An NRI can invest in Gold ETF without PINS account directly with Fund House but in this case investor has to buy or sell in the multiples of 1000 units,”");
                        await stepContext.Context.SendActivityAsync(message);
                        break;
                    case FlightBooking.Intent.tax_gold:
                        message = MessageFactory.Text("Income tax on sale of physical gold: Gold jewellery, coins and bars are subject to capital gains tax when you sell them. If you sell within 3 years of purchase, they are subject to short term capital gains tax and if you sell after 3 years, you will have to pay long term capital gains tax. Gold ETFs are more tax efficient as compared with physical gold.In case of physical gold, capital gains is considered as long term(and therefore taxed at a lower rate) after 3 years whereas in case of ETFs, gains are considered long term after 1 year.");
                        await stepContext.Context.SendActivityAsync(message);
                        break;
                    case FlightBooking.Intent.invest_general:
                        message = MessageFactory.Text("NRIs in India can invest in Fixed Deposit Bank Accounts, Mutual Funds, investing in property in India, Direct Equity, Capital Gain Bonds etc.");
                        await stepContext.Context.SendActivityAsync(message);
                        break;
                    case FlightBooking.Intent.take_loan_general:
                        message = MessageFactory.Text("Taking a loan is a big financial decision which requires you to make informed choices. As an Indian citizen, you need to look into your credit score, rate of interest, processing fee etc. If you are an NRI, You can take loans in India against your NRO deposits subject to standard norms and conditions. ");
                        await stepContext.Context.SendActivityAsync(message);
                        break;
                    case FlightBooking.Intent.greetings:
                        message = MessageFactory.Text("Hello! I can help you with investments in India as an NRI. I can help you know about equity, capital gain bonds, loans, investing in gold, post office, opening an NRO/NRE account and concerned laws.");
                        await stepContext.Context.SendActivityAsync(message);
                        break;
                    case FlightBooking.Intent.take_loan:
                        message = MessageFactory.Text("You can take loans in India against your NRO deposits subject to standard norms and conditions. This loan amount cannot be utilized for re-lending, investment in real estate or carrying on any agricultural/plantation activities.\n\nYou are not allowed to take loans outside India against your NRO deposits.");
                        await stepContext.Context.SendActivityAsync(message);
                        break;
                    case FlightBooking.Intent.attorney:
                        message = MessageFactory.Text("Power of Attorney (POA) lists out the powers that a person wants to share with the POA holder. It is primarily used by NRIS to manage their property, mutual funds, bank accounts, and other investments in India");
                        await stepContext.Context.SendActivityAsync(message);
                        break;
                    case FlightBooking.Intent.buy_property:
                        message = MessageFactory.Text("NRIs can buy and sell residential and commercial properties in India. However the law restricets NRIs from purchasing any kind of agricultural land/ plantation property/ farm house in India.\n\nRBI's permission is not required to buy house/ office/ residential plot/ commercial plant in India.");
                        await stepContext.Context.SendActivityAsync(message);
                        break;
                    case FlightBooking.Intent.capital_gain_bonds:
                        message = MessageFactory.Text("The gains that arise on the sale of a Long Term Capital Gain Asset are known as Long Term Capital Gains and Capital Gains Tax is levied on such gains. However, such tax can be saved if this amount is invested in specified capital gain bonds. Such bonds are called as Capital Gain Bonds or Section 54EC Bonds");
                        await stepContext.Context.SendActivityAsync(message);
                        break;
                    case FlightBooking.Intent.equity_investments:
                        message = MessageFactory.Text("An equity fund invests 60% or more of its funds in the equity shares of companies, remaining is invested in debt securities / money market instruments.\nThe equity shares investments might be a purely large - cap, mid - cap or small - cap fund or a mixture of market capitalization.This investment mandate will be pre - defined by every fund house.\nMoreover, the investing style may be value - oriented or growth oriented.There are also sectoral funds / thematic funds which invest in certain sectors / themes only");
                        await stepContext.Context.SendActivityAsync(message);
                        break;
                    case FlightBooking.Intent.ipo:
                        message = MessageFactory.Text("The issuing company may issue shares to NRI on the basis of specific or general permission from Gol/RBI. Therefore, individual NRI need not obtain any permission.");
                        await stepContext.Context.SendActivityAsync(message);
                        break;
                    case FlightBooking.Intent.nre_account:
                        message = MessageFactory.Text("Non-Resident (External) Rupee (NRE).This is a Rupee account from which funds are freely repatriable. It can be opened with either funds remitted from abroad or local funds which can be remitted abroad");
                        await stepContext.Context.SendActivityAsync(message);
                        break;
                    case FlightBooking.Intent.nro_account:
                        message = MessageFactory.Text("Non-Resident Ordinary Rupee (NRO). Maintained in Indian Rupees, the NRO Account is an ideal option to manage your Indian earnings and earn interest at same levels as Resident Indians. Any person resident outside India can open a NRO account. Individuals entities of Pakistan nationality origin and entities of Bangladesh origin require the prior approval of the Reserve Bank of India. You can open NRO Savings, Current, Recurring.\nDeposit and Fixed Deposit account depending on your requirements.The funds in NRO account are non - repatriable. However, under certain circumstances, these are allowed to be repatriated.\n\nIndians moving abroad have to either convert their regular savings account into NRO account or close such account.");
                        await stepContext.Context.SendActivityAsync(message);
                        break;

                    default:
                        message = MessageFactory.Text(GetResponseFromWeb(Result));
                        await stepContext.Context.SendActivityAsync(message);
                        break;

                }
            }
            else
            {
                var message = MessageFactory.Text(GetResponseFromWeb(Result));
                        await stepContext.Context.SendActivityAsync(message);
            }
            

            return await stepContext.NextAsync(null, cancellationToken);
        }


        

        // Shows a warning if the requested From or To cities are recognized as entities but they are not in the Airport entity list.
        // In some cases LUIS will recognize the From and To composite entities as a valid cities but the From and To Airport values
        // will be empty if those entity values can't be mapped to a canonical item in the Airport.
       
        /*private async Task<DialogTurnResult> FinalStepAsync(WaterfallStepContext stepContext, CancellationToken cancellationToken)
        {
            // If the child dialog ("BookingDialog") was cancelled, the user failed to confirm or if the intent wasn't BookFlight
            // the Result here will be null.
            /*if (stepContext.Result is BookingDetails result)
            {
                // Now we have all the booking details call the booking service.

                // If the call to the booking service was successful tell the user.

                var timeProperty = new TimexProperty(result.TravelDate);
                var travelDateMsg = timeProperty.ToNaturalLanguage(DateTime.Now);
                var messageText = $"I have you booked to {result.Destination} from {result.Origin} on {travelDateMsg}";
                var message = MessageFactory.Text(messageText, messageText, InputHints.IgnoringInput);
                await stepContext.Context.SendActivityAsync(message, cancellationToken);
            }

            // Restart the main dialog with a different message the second time around
            var promptMessage = "What else can I do for you?";
            return await stepContext.ReplaceDialogAsync(InitialDialogId, promptMessage, cancellationToken);
        }*/
    }
}
