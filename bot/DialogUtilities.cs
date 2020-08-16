using EchoBotDesktop.Entities;
using Microsoft.Bot.Connector;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;

namespace EchoBotDesktop.Utilities
{
    public class DialogUtilities
    {
        public static T ConvertFromJsonObject<T>(object obj)
        {
            if (obj == null)
            {
                return default(T);
            }

            return JsonConvert.DeserializeObject<T>(JsonConvert.SerializeObject(obj));
        }

        public static void StoreInDilogState(Dictionary<string, object> DialogState, string key, object value)
        {
            if (value != null)
            {
                DialogState[key] = JsonConvert.SerializeObject(value);
            }
            else
            {
                DialogState[key] = string.Empty;
            }
        }

        public static T FetchFromDilogState<T>(Dictionary<string, object> dialogState, string key, T defaultValue = default(T))
        {
            if (dialogState.ContainsKey(key))
            {
                string valueJson = dialogState[key].ToString();

                if (!string.IsNullOrWhiteSpace(valueJson))
                {
                    return JsonConvert.DeserializeObject<T>(valueJson);
                }
            }

            return defaultValue;
        }

        /*public static HeroCard ParseHeroCard(string answer)
        {
            string data = answer.Replace("&quot;", "\"");
            try
            {
                return JsonConvert.DeserializeObject<HeroCard>(data);
            }
            catch (Exception)
            {
                return null;
            }
        }*/

        /*public static int GetEligibleAnswersCount(QueryResponse response)
        {
            if (response == null)
            {
                return 0;
            }

            if (response.answers.Count > 1 && response.answers[0].score > 30f)
            {
                for (int i = 1; i < response.answers.Count; i++)
                {
                    if ((response.answers[i - 1].score - response.answers[i].score) > 5)
                    {
                        return i;
                    }
                }

                return response.answers.Count;
            }
            else if (response.answers.Count == 1 && response.answers[0].score > 30f)
            {
                return 1;
            }

            return 0;
        }*/

        /*public static bool IsValidConversation(Activity activity)
        {
            if (activity == null)
            {
                return false;
            }

            //Validate activities from Kaizala
            if (Constants.KAIZALA_CHANNEL_ID.Equals(activity.ChannelId))
            {
                if (activity.ChannelData == null)
                {
                    return false;
                }

                Dictionary<string, object> channelDataDict = null;

                try
                {
                    channelDataDict = JsonConvert.DeserializeObject<Dictionary<string, object>>(JsonConvert.SerializeObject(activity.ChannelData));
                }
                catch
                {
                    return false;
                }

                if (channelDataDict != null && channelDataDict.ContainsKey(Constants.KAIZALA_CHANNEL_DATA_TENANT_ID_KEY) &&
                    channelDataDict[Constants.KAIZALA_CHANNEL_DATA_TENANT_ID_KEY] is string)
                {
                    string channelDataTenantId = channelDataDict[Constants.KAIZALA_CHANNEL_DATA_TENANT_ID_KEY] as string;

                    return Constants.SHOULD_VALIDATE_TENANT_INFO || Constants.TENANT_ID.Equals(channelDataTenantId, StringComparison.InvariantCultureIgnoreCase);
                }

                return false;
            }

            return true;
        }*/
    }
}