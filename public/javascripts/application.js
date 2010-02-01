// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


function manipulateDOM() {

    // replace the ordinary buttons with nice image_buttons
    $('.move_submit').after(
      '<input type="image" class="move_submit" id="move_submit" name="commit" src="/images/dummy.png">'
      ).remove()

    $('.exit_round').after(
      '<input type="image" class="exit_round" id="round_submit" name="commit" src="/images/exit.png">'
      ).remove()
    
    $('.play_again').after(
      '<input type="image" class="play_again" id="round_submit" name="commit" src="/images/again.png">'
      ).remove()


    // add mouseover functionality to these buttons
    $('.move_submit').hover(
      function() { $(this).attr({ src : '/images/_x.png'});     },
      function() { $(this).attr({ src : '/images/dummy.png'});  } )

    $('.exit_round').hover(
      function() { $(this).attr({ src : '/images/_exit.png'});  },
      function() { $(this).attr({ src : '/images/exit.png'});   } )

    $('.play_again').hover(
      function() { $(this).attr({ src : '/images/_again.png'});  },
      function() { $(this).attr({ src : '/images/again.png'});   } )


    // get id of the current round (there is perhaps a smarter way)
    var id = $('.edit_round').attr('action')
    id = id.substring(id.lastIndexOf('/')+1)
    
    // make them at least to ajaxforms
    $('.move_form').ajaxForm(function(){
      $('#main').load('/rounds/'+id+'.js',function(){manipulateDOM()})
      })


    }

$(document).ready(manipulateDOM);

