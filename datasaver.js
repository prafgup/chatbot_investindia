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
    },
    UpdatedAt:{
        type: String
    }
})




const dataArr=[ { _id: '5d199d0c26996e84f898f8ac',
Title: '\'Silver\' is the new \'Gold\'',
Description:
 'Silver is hitting new all-time high records every day just like gold and is becoming more popular among commodities investors. Unlike gold, however, silver is not available in paper form (there are no silver ETFs) and therefore, investors have no option but to buy the metal in its physical form or in the futures market from the commodity exchanges. Buying silver bars or coins is the first option.\n\n++++ Silver bars are now available from 100 gm onwards making it easier for investors to purchase and store the metal.++++',
Priority: 1,
IsActive: true,
UpdatedAt: '2019-11-05T13:22:03.000Z' },
{ _id: '5d199d93b0028c84f8438cb3',
Title: 'Market Updates',
Description:
 'Company            Price (Rs.)            CHG%\n\nNIFTY                 10925.65             -147.80\nSENSEX              37076.80            -530.09 \n\nTop gainers:\nJUBILANT :         Rs 862.8              +8.53%\nFUTUREVENT:   Rs 11.75              +4.91%\nTATAMOTORS:   Rs 109.5              +4.63%\nRPOWER:          Rs  3.45              +4.55%\nALKEM:              Rs 2775.05           +4.24%\n',
Priority: 2,
IsActive: true,
UpdatedAt: '2019-10-06T14:27:42.000Z' },
{ _id: '5d199d9fb0028c84f8438cb4',
Title: 'Home Loan Refinancing',
Description:
 'Recently, SBI has announced a rate cut and the existing rate for SBI home loan is in the range of 7.2 per cent to 7.6 per cent. HDFC also has cut its mortgage lending rate by 15 basis points. NRIs paying higher interest on home loans can consider refinancing their home loan to reduce your monthly EMI burden and increase your interest cost savings. ++++You can also opt for fixed rates on new loans to lock-in lower rates for the entire term.++++ Note that there might be some pre-closure charges and processing fees and valuation fees on the new loan. The new bank/lender would treat your request for a home loan as fresh and hence, you will have to go through all procedures again.',
Priority: 3,
IsActive: true,
UpdatedAt: '2019-11-05T13:21:54.000Z' },
{ _id: '5d199da9b0028c84f8438cb5',
Title: 'Review your insurances cover amidst the COVID 19 crisis',
Description:
 'The utmost importance insurance plans hold is proven in this COVID-19 scare.A policy of life insurance is the cheapest and safest mode of making a certain provision for one’s family. Having a life insurance plan is important, but equally important is having adequate insurance cover. While NRIs can take term cover from their country of residence, it is strongly recommended that NRIs should also buy life insurance plan in India to secure their families in India and ensure easier claim collection for their families in India.The utmost importance insurance plans hold is proven in this COVID-19 scare.++++ HDFC Life offers a range of life insurance plans & policies specifically to meet everyone’s needs. ++++ Go here for a look https://www.hdfclife.com/nri-insurance-plans',
Priority: 4,
IsActive: true,
UpdatedAt: '2020-01-21T09:51:55.000Z' },
{ _id: '5d199db6b0028c84f8438cb6',
Title: 'Real estate is calling you',
Description:
 'In the last 8 weeks, residential real estate in India has seen interest from NRIs. Possibly, NRIs are considering having a home base in India in case they have to return back to India. A survey conducted by Knight Frank India showed that both residential and commercial real estate sectors are expected to be hit in terms of launches, sales and prices. Real estate prices are expected to fall down by 15-20 per cent in India.',
Priority: 5,
IsActive: true,
UpdatedAt: '2019-10-06T15:26:33.000Z' },
{ _id: '5d199db6b0028c84f8438cb7',
Title: 'TDS exemption certificate/DTAA provisions',
Description:
 'Imagine your existing investment returns improving by 30 per cent? Yes, TDS exemption certificate and Double Taxation Avoidance Agreements can help you in this. ++++Under the Indian Income Tax laws, anyone making any payment to NRI is required to deduct taxes at stipulated rates unless specified otherwise. ++++If you are having NRO accounts or drawing any rental incomes in India, you would have noticed a 31.2 percent deduction from your interest/rental Income.',
Priority: 6,
IsActive: true,
UpdatedAt: '2019-10-06T15:26:33.000Z' },
{ _id: '5d199db6b0028c84f8438cb8',
Title: 'Invest in equities in a staggered manner',
Description:
 'With the Sensex and Nifty down by more than 30 percen, NRIs can start with gradual and incremental investments into Indian equities. You can either allocate fresh money to equities or shift some money from debt to equities in a staggered manner provided you don’t need this money for the next 3 years.\n\n++++If you have existing equity investments, do review your portfolio holdings and book losses (if any) on the fundamentally weak companies.++++ Instead, you can invest in quality large-cap companies with a strong balance sheet, robust business models and good corporate governance. ++++It is advisable not to have more than 10 percent of your equity investments in a particular company.++++ Also, do not go overboard in a particular sector, rather have sector diversification to reduce portfolio volatility.',
Priority: 7,
IsActive: true,
UpdatedAt: '2019-10-06T15:26:33.000Z' },
{ _id: '5d199db6b0028c84f8438cb9',
Title: 'NRE Interest rates comparison',
Description:
 'Bank      Duration      Interest Rate\n\n++++SBI – NRE Term Deposit++++ 1 year- 2 years      6.70%   \n3 years- 5 years    6.80% \n++++SBI – NRO Term Deposit++++46 days-179 days    6.25% \n3 years – 5 years     6.80% \n++++HDFC –  NRE Term Deposit++++1 year 17 days – 2 Years   7.30% \n 3 years 1day – 5 years       7.25% \n++++HDFC NRO Term Deposit++++46-60 days                            6.25% \n3 years 1 day – 5years       7.25% \n++++ICICI – NRE Term Deposit++++1 year -389 days                  6.90% \n3 years 1 day – 5years       7.25% \n++++ICICI – NRO Term Deposit++++46 days-60 days                   6.00% \n3 years 1 day – 5 years        7.25% \n',
Priority: 8,
IsActive: true,
UpdatedAt: '2019-10-06T15:26:33.000Z' } ]



dataArr.forEach(function(e){
    const me=new tipsdata(e);
    me.save().then((user)=>{
        console.log(user)
    }).catch(e=>{
        console.log(e)
    })
})

app.listen(port,()=>{
    console.log("datasaver Started with port",port )
})