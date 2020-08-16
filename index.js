const request=require('request')
const express=require("express")
const bodyParser=require('body-parser')
const mongoose = require('mongoose')
const { v4: uuidv4 } = require('uuid');
const app=express()

app.use(bodyParser.json())

mongoose.connect('mongodb://127.0.0.1:27017/SIHData', {
    useNewUrlParser: true,
    useCreateIndex: true,
    useUnifiedTopology: true
})


port=3000




const serviceurl="http://2afc020cc18a.ngrok.io"

var jsonBotPostObject2={ channelData:
    { clientActivityID: '1596270539852bxebx4ca6g',
      clientTimestamp: '2020-08-01T08:28:59.852Z',
      state: 'sent' },
   text: 'how to open bank account',
   textFormat: 'plain',
   type: 'message',
   channelId: 'emulator',
   from:
    { id: 'df04e88c-48b6-46b4-ad85-52353e29cadb',
      name: 'User',
      role: 'user' },
   locale: 'en-US',
   timestamp: '2020-08-01T08:28:59.855Z',
   entities:
    [ { requiresBotState: true,
        supportsListening: true,
        supportsTts: true,
        type: 'ClientCapabilities' } ],
   conversation: { id: '003cc670-d3d1-11ea-8fcb-972a8eb5a9ef|livechat' },
   id: '0c708df0-d3d1-11ea-a38e-91324a5c7148',
   localTimestamp: '2020-08-01T13:58:59+05:30',
   recipient:
    { id: 'cfb10f80-d3cf-11ea-8fcb-972a8eb5a9ef',
      name: 'Bot',
      role: 'bot' },
   serviceUrl: serviceurl }


var jsonBotPostObject={ channelData:
    { clientActivityID: '1595836380330g5lkbj21p7q',
      clientTimestamp: '2020-07-27T07:53:00.330Z',
      state: 'sent' },
   text: 'how to  loan in india',
   textFormat: 'plain',
   type: 'message',
   channelId: 'emulator',
   from:
    { id: '59f436bd-5385-4486-a5c0-6f663b95b0e4',
      name: 'User',
      role: 'user' },
   locale: 'en-US',
   timestamp: '2020-07-27T07:53:00.333Z',
   entities:
    [ { requiresBotState: true,
        supportsListening: true,
        supportsTts: true,
        type: 'ClientCapabilities' } ],
   conversation: { id: '29649b50-cfde-11ea-94b0-4797d4e96dfa|livechat' },
   id: '3132e5d0-cfde-11ea-ad34-19122cac892d',
   localTimestamp: '2020-07-27T13:23:00+05:30',
   recipient:
    { id: '75888790-cfba-11ea-94b0-4797d4e96dfa',
      name: 'Bot',
      role: 'bot' },
   serviceUrl: serviceurl }

var jsonBotPostObject3={ channelData:
    { clientActivityID: '15962705627568pkckzb0co6',
      clientTimestamp: '2020-08-01T08:29:22.756Z',
      state: 'sent' },
   npmtext: 'How can I buy property in India',
   textFormat: 'plain',
   type: 'message',
   channelId: 'emulator',
   from:
    { id: 'df04e88c-48b6-46b4-ad85-52353e29cadb',
      name: 'User',
      role: 'user' },
   locale: 'en-US',
   timestamp: '2020-08-01T08:29:22.759Z',
   conversation: { id: '003cc670-d3d1-11ea-8fcb-972a8eb5a9ef|livechat' },
   id: '1a176d70-d3d1-11ea-a38e-91324a5c7148',
   localTimestamp: '2020-08-01T13:59:22+05:30',
   recipient:
    { id: 'cfb10f80-d3cf-11ea-8fcb-972a8eb5a9ef',
      name: 'Bot',
      role: 'bot' },
   serviceUrl: serviceurl }


///////////////////////////////////////////////////////Models///////////////////////////////////////////////////
const User=mongoose.model('User',{
    id:{ 
        type:String
    },
    from:{
        type:Object,
        default:null
    },
    recipient:{
        type:Object,
        default:null
    },
    text:{ 
        type: String,
        required:true
    },
    time : { type : Date, default: Date.now }

})

const tipsdata=mongoose.model('Tipsdata',{
    Title:{
        type:String
    },
    Description:{
        type:String
    },
    Priority:{
        type:Number
    },
    IsActive:{
        type:Boolean
    }
})



/////////////////////////////////////////////////Connections//////////////////////////////////////////////////////


app.post('/app', (req,res)=>{
    console.log(req.body.UserInput)
    jsonBotPostObject2.id=uuidv4();
    jsonBotPostObject2.text=req.body.UserInput
  //  console.log(jsonBotPostObject2)
        const options={
            url: "https://07283c89766a.ngrok.io/api/messages",
            json:true,
            method: "POST",
            body:jsonBotPostObject2,
            headers:{
                'content-type': 'application/json',
            }
        }
        request(options
        ,(error,response)=>{
            if(error){
                console.log(error)
            }else{
                console.log("LIl")
            }
        })
        // setTimeout(function(){
        //     User.findOne({}, {}, { sort: { 'time' : -1 } }).then((user)=>{
        //         res.send(user)
        //     }).catch(err=>{
        //         console.log(err)
        //     });
        // },5000)
        // setTimeout(function(){
        //     User.findOne({from:jsonBotPostObject2.recipient}).then((user)=>{
        //         res.send(user)
        //     }).catch(e=>{
        //         console.log(e)
        //     })
        // },3000)
        // setTimeout(function(){
        //     User.find({id:jsonBotPostObject2.id}).then((user)=>{
        //         res.send(user)
        //     }).catch(e=>{
        //         console.log(e)
        //     })


        // },15000)
        var flag=1;
            setInterval(function(){
                if(flag){
                User.find({id:jsonBotPostObject2.id}).then((user)=>{{
                    //console.log(user.length)
                    if(user.length!==0){
                        flag=0;
                        return res.send(user)
                    }
                }}).catch(e=>{
                    console.log(e)
                })
            }
            },100)

    }
)

app.post('/testing',(req,res)=>{
    const object=req.body
    console.log(object)
})
app.post('/*',(req,res)=>{
    res.status(200).send({"id":"8df29060-d414-11ea-a38e-91324a5c7148"})
    const me =new User({
        id:req.body.replyToId,
        from:req.body.from,
        recipient:req.body.recipient,
        text:req.body.text
    })
    me.save().then(()=>{
        console.log(me)
    }).catch(err =>{
        console.log(err)
    })
    

})

app.get('/tips',(req,res)=>{
    tipsdata.find({}).then((user)=>{
        res.send({
            status:200,
            message:null,
            data:{
                TipsData:user
            }
        })
        console.log(user)
        res.end()
    })
})





////////////////////////////////////////////////Listen///////////////////////////////////////////


app.listen(port,()=>{
    console.log("server started with port " +port)
})