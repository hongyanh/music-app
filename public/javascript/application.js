$(document).ready(function() {

  // $vote_btn = $('.vote')[0]

    $("button.like").click(function(){
      $vote_num = $(this).find(".votes");
      $like_btn = $(this);
      $track_id = $like_btn.attr("id").split('-')[1];
      $.ajax({
        type: "POST",
        url:"/track/vote",
        data: { id: $track_id },
        success:function(result){
        // $vote_num.html(result);
        $like_btn.replaceWith('<div class="left like like-show"><i class="fi-like"></i><span class="votes"> '+ result +' </span></div>');
      }});
    });

});
