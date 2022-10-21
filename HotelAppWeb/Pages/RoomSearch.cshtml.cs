using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using HotelAppLibrary.Databases;
using HotelAppLibrary.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace HotelAppWeb.Pages
{
    
    public class RoomSearchModel : PageModel
    {
        private IDatabaseData _db;

        [DataType(DataType.Date)]
        [BindProperty(SupportsGet = true)]
        public DateTime StartDate { get; set; } = DateTime.Now;

        [DataType(DataType.Date)]
        [BindProperty(SupportsGet = true)]
        //[BindProperty]
        public DateTime EndDate { get; set; } = DateTime.Now.AddDays(1);

        [BindProperty(SupportsGet = true)]
        public bool SearchEnabled { get; set; } = false;
        public List<RoomTypeModel> AvailRoomTypes { get; set; }

        public RoomSearchModel(IDatabaseData db)
        {
            _db = db;
        }
        public void OnGet()
        {
            if (SearchEnabled == true) {
               AvailRoomTypes = _db.GetAvialableRoomTypes(StartDate, EndDate);
            }
        }

        public IActionResult OnPost() {

            return RedirectToPage(new { SearchEnabled = true, StartDate = StartDate.ToString("yyyy-MM-dd"), EndDate = EndDate.ToString("yyyy-MM-dd") });
        }
    }
}
