import React, { useState } from 'react'
import './Testimonials.css'
import { testimonialsData } from '../../assets/testimonialsData'
import RightArrow from '../../images/rightArrow.png'
import leftArrow from '../../images/leftArrow.png'
import {motion} from 'framer-motion'
import axios from 'axios'
import { useEffect } from 'react'



const Testimonial = () => {
  const transition = {type:'spring', duration:3}

  const [selected, setSelected] = useState(0)
  const [newData, setNewData] = useState([])
  const tLength = testimonialsData.length
  // console.log(testimonialsData[selected])
  
  useEffect(() =>{
    axios("https://phase-2-api.herokuapp.com/testimonials")
    .then((data) => {setNewData(data.data)})
  },[])

  // const retData = (newData) =>{
  //   newData.forEach((item)=> {
  //     return item.review
  //   })
  // }
  // console.log(newData.forEach((item)=>{
  //   console.log(item.review)
  // }))
  const revDisplay = newData.map((item) => {
    return(
    item.review

    )
  }) 
  const nameDisplay = newData.map((item)=>{
    return(
      item.name
    )
  })
  const statusDisplay = newData.map((item)=>{
    return(
      item.status
    )
  })
  const imgDisplay = newData.map((item)=>{
    return(
      item.image
    )
  })


  
  return (
    <div className="testimonials">
        <div className="left-t">
            <span>Testimonials</span>
            <span className='stroke-text'>What they</span>
            <span>say about us</span>

            <span>{revDisplay[selected]}</span>

            {/* <span>{testimonialsData[selected].review}</span> */}
            {/* <span style={{color:"var(--orange)"}}>{testimonialsData[selected].name} - {testimonialsData[selected].status}</span> */}
            <span style={{color:"var(--orange)"}}>{nameDisplay[selected]} - {statusDisplay[selected]}</span>
            {/* <span>{imgDisplay}</span> could not display image through api */} 
            <span>{imgDisplay}</span>
        </div>

        <div className="right-t">
          <motion.div
          initial={{opacity:0, x:-100}}
          transition={{...transition, duration:2}}
          whileInView={{opacity:1, x:0}}
          >

          </motion.div>

          <motion.div
                    initial={{opacity:0, x:100}}
                    transition={{...transition, duration:2}}
                    whileInView={{opacity:1, x:0}}
          >

          </motion.div>
          <img src={testimonialsData[selected].image} alt="" />
          <div className="arrows">
            <img
            onClick={() => {
              selected === 0 
            ? setSelected(tLength -1)
            : setSelected((prev) => prev -1) }} 
             src={leftArrow} alt="" />

            <img 
            onClick={() => {
              selected === tLength - 1
            ? setSelected(0)
            : setSelected((prev) => prev + 1) }} 
            src={RightArrow} alt="" />
          </div>
        </div>


    </div>
  )
}

export default Testimonial