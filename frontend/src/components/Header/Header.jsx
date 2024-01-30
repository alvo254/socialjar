import React from 'react'
import './Header.css'
import Logo from '../../images/logo.png'
import { Link } from 'react-router-dom'

function Header() {
  return (
    <div className='header'>
        {/* <img src={Logo} alt="" className='logo'/> */}
        <h1 className='pic'> <Link to="/"> Fitness Hero</Link> </h1>
        <ul className='header-list'>
            <li><Link to="/">Home</Link></li>
            <li><Link to="/programs">Programs</Link></li>
            <li><Link to="/plans">Plans</Link></li>
            <li><Link to="/Testimonial">Testimonial</Link></li>
            <li><Link to="/Join">Join</Link></li>
        </ul>
    </div>
  )
}

export default Header