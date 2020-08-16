const request=require('request')
const express=require("express")
const bodyParser=require('body-parser')
const mongoose = require('mongoose')
const { v4: uuidv4 } = require('uuid');
const { mongo } = require('mongoose');
const app=express()

app.use(bodyParser.json())

mongoose.connect('mongodb://127.0.0.1:27017/SIHData', {
    useNewUrlParser: true,
    useCreateIndex: true,
    useUnifiedTopology: true
})


port=3000


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

app.listen(port,()=>{
    console.log("Started listening to port",port )
})