package progra4.prestamos.controller;

import progra4.prestamos.model.Empresa;
import progra4.prestamos.model.Oferente;
import progra4.prestamos.service.EmpresaService;
import progra4.prestamos.service.OferenteService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/registro")
@RequiredArgsConstructor
public class RegistroController {

    private final EmpresaService empresaService;
    private final OferenteService oferenteService;

    @GetMapping("/empresa")
    public String formEmpresa(Model model) {
        model.addAttribute("empresa", new Empresa());
        return "public/registro-empresa";
    }

    @PostMapping("/empresa")
    public String registrarEmpresa(@ModelAttribute Empresa empresa) {
        empresaService.registrar(empresa);
        return "redirect:/login?registroOk=true";
    }

    @GetMapping("/oferente")
    public String formOferente(Model model) {
        model.addAttribute("oferente", new Oferente());
        return "public/registro-oferente";
    }

    @PostMapping("/oferente")
    public String registrarOferente(@ModelAttribute Oferente oferente) {
        oferenteService.registrar(oferente);
        return "redirect:/login?registroOk=true";
    }
}