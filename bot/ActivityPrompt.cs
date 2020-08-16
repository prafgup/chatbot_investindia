using Microsoft.Bot.Builder.Dialogs;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Bot.Schema;
namespace CoreBot.MyActivityPrompt
{
	public class EventActivityPrompt : ActivityPrompt
    {
        public EventActivityPrompt(string dialogId, PromptValidator<Activity> validator)
            : base(dialogId, validator)
        {
            Activity activity = new Activity();
            

        }
        async Task<bool> _validator(PromptValidatorContext<Activity> promptContext, CancellationToken cancellationToken)
        {
            var activity = promptContext.Recognized.Value;
            if (activity.Type == ActivityTypes.Event)
            {
                return true;
            }
            return false;
        }
    }
    
}
