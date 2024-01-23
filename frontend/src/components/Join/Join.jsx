import React, { useRef } from 'react'
import './Join.css'
import emailjs from '@emailjs/browser'

const Join = () => {
    const form = useRef()

    const sendEmail = (e) => {
        e.preventDefault();
    
        emailjs.sendForm('service_zi6ou0l', 'template_f86ackl', form.current, 'axr3nhlbluTqFw4nE')
          .then((result) => {
              console.log(result.text);
          }, (error) => {
              console.log(error.text);
          });
      };

  return (
    <div className="Join">
        <div className="left-j">
            <hr />
            <div>
                <span className='stroke-text'>READY TO</span>
                <span>LEVEL UP</span>
            </div>
            <div>
                <span>YOUR BODY</span>
                <span className='stroke-text'>WITH US</span>
            </div>
        </div>

        <div className="right-j">
            <form ref={form} className="email-cont" onSubmit={sendEmail}>
                <input type="email"  name='user_email' placeholder='Enter your email'/>
                <button className='btn btn-j'>Join now</button>
            </form>
        </div>
    </div>
  )
}

export default Join