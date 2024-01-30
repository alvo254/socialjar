import React from 'react'
import './Hero.css'
// import Header from '../Header/Header.jsx'
import hero_image from '../../images/hero_image.png'
import hero_image_back from '../../images/hero_image_back.png'
import Heart from "../../images/heart.png"
import Calories from '../../images/calories.png'
import {motion} from 'framer-motion'


function Hero() {
  const transition = {type: 'spring', duration: 3}
  return (
    <div className="hero">
      <div className="blur hero-blur"></div>
        <div className="left">
        {/* <Header/> */}
        <div className="add">
          <motion className="div"></motion>
          <motion.div
          initial={{left:'230px'}}
          whileInView={{left: '8px'}}
          transition={{...transition, type: 'tween'}}
          >

          </motion.div>
          <span>The best fitness gym around you</span>
        </div>

        <div className="hero-text">
          <div>
            <span className='stroke-text'>Shape </span>
            <span>Your</span>
          </div>
          <div>
            <span>Ideal body</span>
        </div>
        <div>
          <span>Lorem ipsum dolor sit amet consectetur adipisicing elit. 
            Corporis provident, illum neque atque assumenda ducimus id consequuntur 
            eos mollitia facilis placeat officiis a dolor enim voluptatum obcaecati 
            aperiam, natus dolorem!</span>
        </div>
        </div>

        <div className="figures">

        <div>
          <span>+140</span>
          <span>expert coachs</span>
         </div>
         <div>
          <span>+978</span>
          <span>members joined</span>
         </div>
         <div>
          <span>+50</span>
          <span>fitness programs</span>
         </div>


        </div>

        <div className="hero-btn">
          <buttons className="btn">Get Started</buttons>
          <buttons className="btn">Learn More</buttons>
        </div>

        </div>

        <div className="right">
          <button className='btn'>Join Now</button>
          
          <motion.div className="hear-rate"
          initial={{right:'-1rem'}}
            transition={transition}
            whileInView={{right:'4rem'}}
          >
            <img src={Heart} alt="" />
            <span>Heart rate</span>
            <span>116 bpm</span>

          </motion.div>

          <img src={hero_image} alt="" className='hero-image'/>
          <motion.img 
                    initial={{right:'12rem'}}
                    whileInView={{right:'26rem'}}
                    transition={transition}
          src={hero_image_back} alt="" className='hero-image-back'/>

          <motion.div className="calories"
                    initial={{right:'47rem'}}
                    transition={transition}
                    whileInView={{right:'38rem'}}
          >
            <img src={Calories} alt="" />
            <div>
              <span>Calories Burned</span>
              <span>220 Kcalc</span>
            </div>
            
          </motion.div>

        </div>

    </div>
  )
}

export default Hero