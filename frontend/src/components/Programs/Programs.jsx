import React, { useState } from 'react'
import './Programs.css'
import {programsData} from '../../assets/programsData'
import RightArrow from '../../images/rightArrow.png'
import { useEffect } from 'react'
import axios from 'axios'

function Programs() {

    const [addData, setData] = useState([])


    // useEffect(()=>{
    //     axios("http://localhost:3004/exercies")
    //     .then((recv) => {setData(recv.data)})

    // },[])
    useEffect(()=>{
        axios.get("https://programdata.herokuapp.com/exercies")
        .then((resc) => {setData(resc.data)})
    },[])



    //For personal learning
    // fetch("http://localhost:3004/exercies", {
    //     method:"POST", headers:{"Content-Type":"application/json"},
    //     body:JSON.stringify({
    //         heading: "hapa",
    //         detail: "up up"
    //     })

    // })
    // .then((resp) => console.log('data', resp))
    // .then((err) => console.log(err))

    // axios.post("http://localhost:3004/exercies", {
    //     heading: "situp",

    // })
    // .then((resp) => {console.log(resp)})
    // .then((err)=>{console.log(err)})


  return (
    <div className="Programs" id="programs">
        <div className="program-header">
            <span className='stroke-text'>Explore our</span>
            <span>Programs</span>
            <span className='stroke-text'>to shape you</span>
        </div>
        <div className="program-cat">
            {addData.map((programs) => (
                <div className="category">
                    {programs.image}
                    <span>{programs.heading}</span>
                    <span>{programs.details}</span>

                    <div className="join-now">
                        <span>Join Now</span>
                        <img src={RightArrow} alt="" />
                    </div>
                </div>
            ))}
        </div>
    </div>
  )
}

export default Programs