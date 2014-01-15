
#= require util/gateway

window.meldd_gateway.register 'CsatVhDummiedForm', ->
  '''
  <form id='form1'>
    <div class='col-md-5'>
      <div class='panel panel-default'>
        <div class='panel-heading'>
          <h2 class='panel-title'>Selection Start</h2>
        </div>
        <div class='panel-body' id='start_panel'>
          <div class='form-group'>
            <label for='start_selector'>Selector</label>
            <select id='start_selector'></select>
          </div>
          <div class='form-group'>
            <label for='start_nodeindex'>
              Node Index
              <strong>(includes child element nodes!)</strong>
            </label>
            <input class='form-control validate[required,funcCall[window.checkNodeIndex]' id='start_nodeindex' name='start-nodeindex' type='number'>
          </div>
          <div class='form-group'>
            <label or='start_textoffset'>Text Offset</label>
            <input class='form-control validate[required,funcCall[window.checkTextOffset]' id='start_textoffset' name='start-textoffset' type='number'>
          </div>
        </div>
      </div>
    </div>
    <div class='col-md-5'>
      <div class='panel panel-default'>
        <div class='panel-heading'>
          <h2 class='panel-title'>Selection End</h2>
        </div>
        <div class='panel-body' id='end_panel'>
          <div class='form-group'>
            <label for='end_selector'>Selector</label>
            <select id='end_selector'></select>
          </div>
          <div class='form-group'>
            <label for='end_nodeindex'>
              Node Index
              <strong>(includes child element nodes!)</strong>
            </label>
            <input class='form-control validate[required,funcCall[window.checkNodeIndex]' id='end_nodeindex' name='end-nodeindex' type='number'>
          </div>
          <div class='form-group'>
            <label or='end_textoffset'>Text Offset</label>
            <input class='form-control validate[required,funcCall[window.checkTextOffset]' id='end_textoffset' name='end-textoffset' type='number'>
          </div>
        </div>
      </div>
    </div>
    <div class='col-md-2'>
      <button class='btn btn-primary' type='submit'>Select</button>
    </div>
  </form>
  '''
