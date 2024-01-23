import React from 'react'
import Logo from '../../images/logo.png'


const nav = () => {
  return (
    <div className='header'>
        <img src={Logo} alt="" className='logo'/>
        <ul className='header-list'>
            <li>Home</li>
            <li>Programs</li>
            <li>why us</li>
            <li>Plans</li>
            <li>Testimonials</li>
        </ul>
    </div>
  )
}

export default nav
